#if os(macOS)
import AppKit
@preconcurrency import ApplicationServices
import CoreGraphics

@available(macOS 13.0, *)
@MainActor
final class SettingsWindowTracker {
    /// Polling remains enabled even when AX is available because System Settings
    /// can appear before accessibility observers are fully attached.
    private let pollInterval: TimeInterval = 1.0 / 30.0

    /// Temporary lookup misses are common while System Settings opens or swaps
    /// privacy panes. Requiring several misses avoids false "window closed"
    /// detection and keeps the floating panel stable.
    private let missingAppThreshold = 12

    var onFrameChange: ((CGRect) -> Void)?
    var onTrackingEnded: (() -> Void)?
    private(set) var currentFrame: CGRect?

    private let bundleIdentifier = "com.apple.systempreferences"
    private var appObserver: AXObserver?
    private var windowObserver: AXObserver?
    private var observedWindow: AXUIElement?
    private var pollTimer: Timer?
    private var hasActiveTrackingTarget = false
    private var missingAppPollCount = 0

    func startTracking(promptIfNeeded: Bool) {
        if promptIfNeeded {
            requestAccessibilityTrust()
        }

        stopTracking()

        pollTimer = Timer.scheduledTimer(withTimeInterval: pollInterval, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.attachIfNeeded()
            }
        }
        pollTimer?.tolerance = pollInterval * 0.25
        attachIfNeeded()
    }

    func stopTracking() {
        pollTimer?.invalidate()
        pollTimer = nil

        if let observer = appObserver {
            CFRunLoopRemoveSource(
                CFRunLoopGetMain(),
                AXObserverGetRunLoopSource(observer),
                .commonModes
            )
        }
        if let observer = windowObserver {
            CFRunLoopRemoveSource(
                CFRunLoopGetMain(),
                AXObserverGetRunLoopSource(observer),
                .commonModes
            )
        }

        appObserver = nil
        windowObserver = nil
        observedWindow = nil
        currentFrame = nil
        hasActiveTrackingTarget = false
        missingAppPollCount = 0
    }

    private func requestAccessibilityTrust() {
        let options = ["AXTrustedCheckOptionPrompt": true] as CFDictionary
        _ = AXIsProcessTrustedWithOptions(options)
    }

    private func attachIfNeeded() {
        guard let app = NSRunningApplication.runningApplications(withBundleIdentifier: bundleIdentifier).first else {
            finishTrackingIfNeededBecauseAppExited()
            return
        }

        hasActiveTrackingTarget = true
        missingAppPollCount = 0

        updateFrameFromWindowServer(for: app.processIdentifier)
        guard AXIsProcessTrusted() else { return }

        let appElement = AXUIElementCreateApplication(app.processIdentifier)

        if appObserver == nil {
            appObserver = makeObserver(for: app.processIdentifier)
            if let appObserver {
                addNotification(kAXMainWindowChangedNotification as CFString, element: appElement, observer: appObserver)
                addNotification(kAXFocusedWindowChangedNotification as CFString, element: appElement, observer: appObserver)
                CFRunLoopAddSource(
                    CFRunLoopGetMain(),
                    AXObserverGetRunLoopSource(appObserver),
                    .commonModes
                )
            }
        }

        guard let window = mainWindow(for: appElement) else { return }
        guard isSameElement(window, observedWindow) == false else {
            updateCurrentFrame()
            return
        }

        observedWindow = window
        updateWindowObserver(for: app.processIdentifier, window: window)
        updateCurrentFrame()
    }

    private func updateFrameFromWindowServer(for pid: pid_t) {
        guard let frame = windowServerFrame(for: pid) else { return }
        guard currentFrame != frame else { return }
        currentFrame = frame
        onFrameChange?(frame)
    }

    private func updateWindowObserver(for pid: pid_t, window: AXUIElement) {
        if let windowObserver {
            CFRunLoopRemoveSource(
                CFRunLoopGetMain(),
                AXObserverGetRunLoopSource(windowObserver),
                .commonModes
            )
        }

        windowObserver = makeObserver(for: pid)
        if let windowObserver {
            addNotification(kAXMovedNotification as CFString, element: window, observer: windowObserver)
            addNotification(kAXResizedNotification as CFString, element: window, observer: windowObserver)
            CFRunLoopAddSource(
                CFRunLoopGetMain(),
                AXObserverGetRunLoopSource(windowObserver),
                .commonModes
            )
        }
    }

    private func updateCurrentFrame() {
        guard let window = observedWindow else { return }
        guard
            let position = pointValue(for: kAXPositionAttribute, element: window),
            let size = sizeValue(for: kAXSizeAttribute, element: window)
        else { return }

        let frame = appKitScreenFrame(fromAccessibilityPosition: position, size: size)
        guard currentFrame != frame else { return }
        currentFrame = frame
        onFrameChange?(frame)
    }

    private func mainWindow(for appElement: AXUIElement) -> AXUIElement? {
        if let window = elementValue(for: kAXMainWindowAttribute, element: appElement) {
            return window
        }
        if let window = elementValue(for: kAXFocusedWindowAttribute, element: appElement) {
            return window
        }
        return arrayValue(for: kAXWindowsAttribute, element: appElement)?.first
    }

    private func makeObserver(for pid: pid_t) -> AXObserver? {
        var observer: AXObserver?
        let result = AXObserverCreate(pid, { _, _, _, refcon in
            guard let refcon else { return }
            let tracker = Unmanaged<SettingsWindowTracker>.fromOpaque(refcon).takeUnretainedValue()
            DispatchQueue.main.async {
                tracker.attachIfNeeded()
            }
        }, &observer)
        guard result == .success else { return nil }
        return observer
    }

    private func addNotification(_ name: CFString, element: AXUIElement, observer: AXObserver) {
        let refcon = Unmanaged.passUnretained(self).toOpaque()
        _ = AXObserverAddNotification(observer, element, name, refcon)
    }

    private func elementValue(for key: String, element: AXUIElement) -> AXUIElement? {
        var value: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(element, key as CFString, &value)
        guard result == .success else { return nil }
        return (value as! AXUIElement)
    }

    private func arrayValue(for key: String, element: AXUIElement) -> [AXUIElement]? {
        var value: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(element, key as CFString, &value)
        guard result == .success else { return nil }
        return value as? [AXUIElement]
    }

    private func pointValue(for key: String, element: AXUIElement) -> CGPoint? {
        var value: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(element, key as CFString, &value)
        guard result == .success, let axValue = value else { return nil }

        let pointValue = axValue as! AXValue
        guard AXValueGetType(pointValue) == .cgPoint else { return nil }

        var point = CGPoint.zero
        AXValueGetValue(pointValue, .cgPoint, &point)
        return point
    }

    private func sizeValue(for key: String, element: AXUIElement) -> CGSize? {
        var value: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(element, key as CFString, &value)
        guard result == .success, let axValue = value else { return nil }

        let sizeValue = axValue as! AXValue
        guard AXValueGetType(sizeValue) == .cgSize else { return nil }

        var size = CGSize.zero
        AXValueGetValue(sizeValue, .cgSize, &size)
        return size
    }

    private func isSameElement(_ lhs: AXUIElement?, _ rhs: AXUIElement?) -> Bool {
        guard let lhs, let rhs else { return false }
        return CFEqual(lhs, rhs)
    }

    private func windowServerFrame(for pid: pid_t) -> CGRect? {
        guard
            let windows = CGWindowListCopyWindowInfo([.optionOnScreenOnly, .excludeDesktopElements], kCGNullWindowID)
                as? [[String: Any]]
        else { return nil }

        // Choose the largest visible layer-0 window for the System Settings
        // process, which maps well to the main document-sized window.
        let bestMatch = windows
            .filter { window in
                guard let ownerPID = window[kCGWindowOwnerPID as String] as? pid_t else { return false }
                guard ownerPID == pid else { return false }
                let layer = window[kCGWindowLayer as String] as? Int ?? 0
                let alpha = window[kCGWindowAlpha as String] as? Double ?? 1
                return layer == 0 && alpha > 0
            }
            .compactMap { window -> CGRect? in
                guard let bounds = window[kCGWindowBounds as String] as? NSDictionary else { return nil }
                guard let cgBounds = CGRect(dictionaryRepresentation: bounds) else { return nil }
                return appKitScreenFrame(fromWindowServerBounds: cgBounds)
            }
            .max(by: { $0.width * $0.height < $1.width * $1.height })

        return bestMatch
    }

    private func appKitScreenFrame(fromWindowServerBounds bounds: CGRect) -> CGRect {
        let desktopBounds = desktopFrameBounds()
        guard desktopBounds.isNull == false else { return bounds }

        return CGRect(
            x: bounds.minX,
            y: desktopBounds.maxY - bounds.maxY,
            width: bounds.width,
            height: bounds.height
        )
    }

    private func appKitScreenFrame(fromAccessibilityPosition position: CGPoint, size: CGSize) -> CGRect {
        let desktopBounds = desktopFrameBounds()
        guard desktopBounds.isNull == false else {
            return CGRect(origin: position, size: size)
        }

        return CGRect(
            x: position.x,
            y: desktopBounds.maxY - position.y - size.height,
            width: size.width,
            height: size.height
        )
    }

    private func desktopFrameBounds() -> CGRect {
        let desktopBounds = NSScreen.screens
            .map(\.frame)
            .reduce(CGRect.null) { partial, frame in
                partial.union(frame)
            }

        return desktopBounds
    }

    /// Stops tracking only after repeated process misses so short-lived lookup
    /// failures do not close the panel immediately.
    private func finishTrackingIfNeededBecauseAppExited() {
        guard hasActiveTrackingTarget || currentFrame != nil else { return }
        missingAppPollCount += 1
        guard missingAppPollCount >= missingAppThreshold else { return }
        stopTracking()
        onTrackingEnded?()
    }
}
#endif
