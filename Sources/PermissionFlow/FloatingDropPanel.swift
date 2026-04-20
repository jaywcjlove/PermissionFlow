#if os(macOS)
import AppKit
import QuartzCore
import SwiftUI

@available(macOS 13.0, *)
@MainActor
final class FloatingDropPanel: NSPanel {
    private weak var panelController: PermissionFlowController?
    private let hostingView: NSHostingView<PermissionFlowPanelView>
    private let windowSize = NSSize(width: 530, height: 109)

    private let sidebarWidth: CGFloat = 170
    private let screenInset: CGFloat = 8
    private let verticalInset: CGFloat = 14
    private let horizontalOffset: CGFloat = -8

    /// Launch animation constants tuned to feel responsive without making the
    /// panel overshoot or jitter while the target window is still settling.
    private let animationDuration: TimeInterval = 0.72
    private let animationResponse: Double = 0.72
    private let initialAlpha: CGFloat = 0.9
    private let minimumLaunchScale: CGFloat = 0.58
    private var launchTimer: Timer?
    private var launchStartTime: CFTimeInterval = 0
    private var launchFromFrame = NSRect.zero
    private var launchToFrame = NSRect.zero
    private var isAnimatingLaunch = false

    init(controller: PermissionFlowController) {
        panelController = controller
        let panelView = PermissionFlowPanelView(controller: controller)
        hostingView = NSHostingView(rootView: panelView)
        super.init(
            contentRect: CGRect(origin: .zero, size: windowSize),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )

        level = .statusBar
        isReleasedWhenClosed = false
        isOpaque = false
        backgroundColor = .clear
        hasShadow = true
        collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle, .fullScreenAuxiliary]
        hidesOnDeactivate = false
        animationBehavior = .none

        hostingView.translatesAutoresizingMaskIntoConstraints = false
        contentView = hostingView
        setContentSize(windowSize)
    }

    /// The panel intentionally stays non-activating so System Settings remains
    /// the visible focus owner underneath it.
    override var canBecomeKey: Bool { false }

    override var canBecomeMain: Bool { false }

    override func becomeKey() {
        super.becomeKey()
        panelController?.keepSettingsVisible()
    }

    override func becomeMain() {
        super.becomeMain()
        panelController?.keepSettingsVisible()
    }

    override func sendEvent(_ event: NSEvent) {
        if event.type == .leftMouseDown || event.type == .rightMouseDown {
            panelController?.keepSettingsVisible()
        }
        super.sendEvent(event)
    }

    func show() {
        orderFrontRegardless()
    }

    func show(at sourceFrameInScreen: CGRect) {
        stopLaunchAnimation()
        isAnimatingLaunch = false
        alphaValue = 1
        setFrame(launchSourceFrame(for: sourceFrameInScreen), display: false)
        orderFrontRegardless()
    }

    func present(from sourceFrameInScreen: CGRect, to settingsFrame: CGRect) {
        stopLaunchAnimation()
        let targetFrame = targetFrame(for: settingsFrame)

        guard sourceFrameInScreen.isEmpty == false else {
            isAnimatingLaunch = false
            alphaValue = 1
            setFrame(targetFrame, display: false)
            orderFrontRegardless()
            return
        }

        isAnimatingLaunch = true
        launchFromFrame = launchSourceFrame(for: sourceFrameInScreen)
        launchToFrame = targetFrame
        launchStartTime = CACurrentMediaTime()
        alphaValue = initialAlpha
        setFrame(launchFromFrame, display: false)
        orderFrontRegardless()
        stepLaunchAnimation()

        let timer = Timer(timeInterval: 1.0 / 60.0, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.stepLaunchAnimation()
            }
        }
        RunLoop.main.add(timer, forMode: .common)
        launchTimer = timer
    }

    func setDraggingPassthrough(_ isDragging: Bool) {
        ignoresMouseEvents = isDragging
        alphaValue = isDragging ? 0.72 : 1.0
        if isDragging {
            orderBack(nil)
        } else {
            orderFrontRegardless()
        }
    }

    func snap(to settingsFrame: CGRect) {
        let target = targetFrame(for: settingsFrame)
        if isAnimatingLaunch {
            // Tracking updates can arrive during the launch. Updating the final
            // destination preserves the motion instead of abruptly snapping.
            launchToFrame = target
            return
        }

        stopLaunchAnimation()
        setFrame(target, display: false)
        orderFrontRegardless()
    }

    private func targetFrame(for settingsFrame: CGRect) -> CGRect {
        let visibleFrame = NSScreen.screens
            .first(where: { $0.frame.intersects(settingsFrame) })?
            .visibleFrame ?? settingsFrame

        let contentMinX = settingsFrame.minX + sidebarWidth
        let contentWidth = max(settingsFrame.width - sidebarWidth, windowSize.width)
        let preferredX = contentMinX + ((contentWidth - windowSize.width) / 2) + horizontalOffset
        let preferredY = settingsFrame.minY + verticalInset

        let minX = visibleFrame.minX + screenInset
        let maxX = visibleFrame.maxX - windowSize.width - screenInset
        let minY = visibleFrame.minY + screenInset
        let maxY = visibleFrame.maxY - windowSize.height - screenInset

        return CGRect(
            x: min(max(preferredX, minX), maxX),
            y: min(max(preferredY, minY), maxY),
            width: windowSize.width,
            height: windowSize.height
        )
    }

    private func launchSourceFrame(for sourceFrameInScreen: CGRect) -> CGRect {
        let launchSize = CGSize(
            width: max(sourceFrameInScreen.width, frame.width * minimumLaunchScale),
            height: max(sourceFrameInScreen.height, frame.height * minimumLaunchScale)
        )
        let center = CGPoint(x: sourceFrameInScreen.midX, y: sourceFrameInScreen.midY)
        return CGRect(
            x: center.x - (launchSize.width * 0.5),
            y: center.y - (launchSize.height * 0.5),
            width: launchSize.width,
            height: launchSize.height
        )
    }

    private func stepLaunchAnimation() {
        let elapsed = max(0, CACurrentMediaTime() - launchStartTime)
        if elapsed >= animationDuration {
            isAnimatingLaunch = false
            stopLaunchAnimation()
            alphaValue = 1
            setFrame(launchToFrame, display: true)
            return
        }

        let progress = springProgress(at: elapsed)
        alphaValue = initialAlpha + ((1 - initialAlpha) * progress)
        setFrame(curvedFrame(from: launchFromFrame, to: launchToFrame, progress: progress), display: true)
    }

    private func stopLaunchAnimation() {
        launchTimer?.invalidate()
        launchTimer = nil
    }

    private func springProgress(at elapsed: TimeInterval) -> CGFloat {
        let omega = (2 * Double.pi) / animationResponse
        let progress = 1 - exp(-omega * elapsed) * (1 + (omega * elapsed))
        return min(max(progress, 0), 1)
    }

    private func curvedFrame(from: CGRect, to: CGRect, progress: CGFloat) -> CGRect {
        // A quadratic Bezier curve gives the panel a softer "fly to target"
        // motion than a straight linear interpolation.
        let size = CGSize(
            width: from.width + ((to.width - from.width) * progress),
            height: from.height + ((to.height - from.height) * progress)
        )

        let startCenter = CGPoint(x: from.midX, y: from.midY)
        let endCenter = CGPoint(x: to.midX, y: to.midY)
        let midpoint = CGPoint(
            x: (startCenter.x + endCenter.x) * 0.5,
            y: max(startCenter.y, endCenter.y)
        )
        let distance = hypot(endCenter.x - startCenter.x, endCenter.y - startCenter.y)
        let lift = min(140, max(44, distance * 0.18))
        let controlPoint = CGPoint(x: midpoint.x, y: midpoint.y + lift)
        let inverse = 1 - progress
        let center = CGPoint(
            x: (inverse * inverse * startCenter.x) + (2 * inverse * progress * controlPoint.x) + (progress * progress * endCenter.x),
            y: (inverse * inverse * startCenter.y) + (2 * inverse * progress * controlPoint.y) + (progress * progress * endCenter.y)
        )

        return CGRect(
            x: center.x - (size.width * 0.5),
            y: center.y - (size.height * 0.5),
            width: size.width,
            height: size.height
        )
    }
}
#endif
