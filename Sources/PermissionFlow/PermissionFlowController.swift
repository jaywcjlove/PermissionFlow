#if os(macOS)
import AppKit
import Combine
import SystemSettingsKit
import SwiftUI

@available(macOS 13.0, *)
@MainActor
public final class PermissionFlowController: ObservableObject {
    /// The package exposes a single active floating panel at a time so opening
    /// a second permission flow closes the previous panel automatically.
    private static var activeController: PermissionFlowController?
    private let systemSettingsBundleIdentifier = "com.apple.systempreferences"

    /// Apps currently represented in the floating panel.
    @Published public private(set) var droppedApps: [URL]

    /// The permission pane currently being guided.
    @Published public private(set) var currentPane: PermissionFlowPane?

    /// Drives the visibility of the "reopen settings" action.
    @Published var isSettingsFrontmost = false

    public var onDrop: ((URL) -> Void)?

    private let configuration: PermissionFlowConfiguration
    private let tracker = SettingsWindowTracker()

    private var panel: FloatingDropPanel?
    private var pendingLaunchSourceFrame: CGRect?
    private var cancellables = Set<AnyCancellable>()

    public init(configuration: PermissionFlowConfiguration = .init()) {
        self.configuration = configuration
        self.droppedApps = configuration.requiredAppURLs.uniqueAppURLs()

        updateFrontmostAppState()
        bindTrackerCallbacks()
        observeFrontmostApplication()
    }

    /// Opens the requested privacy pane and starts the floating guidance flow.
    public func authorize(
        pane: PermissionFlowPane,
        suggestedAppURLs: [URL] = [],
        sourceFrameInScreen: CGRect? = nil
    ) {
        closeOtherActivePanelIfNeeded()

        currentPane = pane
        pendingLaunchSourceFrame = sourceFrameInScreen
        mergeDroppedApps(with: suggestedAppURLs)
        SystemSettings.open(url: pane.settingsURL)

        Self.activeController = self
        showPanel()
        tracker.startTracking(promptIfNeeded: configuration.promptForAccessibilityTrust)
    }

    /// Shows the panel immediately. If the target System Settings frame is
    /// already known, the panel is positioned or animated into place at once.
    public func showPanel() {
        if panel == nil {
            panel = FloatingDropPanel(controller: self)
        }

        guard let panel else { return }

        if let settingsFrame = tracker.currentFrame {
            presentPanel(panel, for: settingsFrame)
            return
        }

        if let sourceFrame = pendingLaunchSourceFrame {
            panel.show(at: sourceFrame)
        } else {
            panel.center()
            panel.show()
        }
    }

    public func closePanel() {
        tracker.stopTracking()
        panel?.close()
        panel = nil
        pendingLaunchSourceFrame = nil

        if Self.activeController === self {
            Self.activeController = nil
        }
    }

    public func resetDroppedApps() {
        droppedApps = configuration.requiredAppURLs.uniqueAppURLs()
    }

    /// Registers a unique `.app` bundle URL and notifies the host if needed.
    public func registerDroppedApp(_ url: URL) {
        guard url.pathExtension.lowercased() == "app" else { return }

        let normalizedURL = url.standardizedFileURL
        guard droppedApps.contains(normalizedURL) == false else { return }

        droppedApps.append(normalizedURL)
        onDrop?(normalizedURL)
    }

    /// The panel always renders a single primary app card. If the host has not
    /// supplied one yet, the host application's bundle becomes the fallback.
    var preferredAppURL: URL? {
        if let first = droppedApps.first {
            return first
        }

        let bundleURL = Bundle.main.bundleURL.standardizedFileURL
        return bundleURL.pathExtension.lowercased() == "app" ? bundleURL : nil
    }

    /// The panel becomes mouse-transparent while dragging so System Settings
    /// underneath can receive the drop.
    func setPanelDragging(_ isDragging: Bool) {
        panel?.setDraggingPassthrough(isDragging)
    }

    /// Keeps System Settings visually present whenever the floating panel is
    /// clicked or momentarily considered for focus.
    func keepSettingsVisible() {
        SystemSettings.activate()
        panel?.orderFrontRegardless()
    }

    func reopenCurrentSettingsPane() {
        guard let currentPane else { return }
        SystemSettings.open(url: currentPane.settingsURL)
        panel?.orderFrontRegardless()
    }

    /// Merges unique app bundle URLs into the current panel list.
    func mergeDroppedApps(with urls: [URL]) {
        for url in urls.uniqueAppURLs() {
            registerDroppedApp(url)
        }
    }

    private func bindTrackerCallbacks() {
        tracker.onFrameChange = { [weak self] frame in
            Task { @MainActor [weak self] in
                guard let self else { return }
                self.presentPanel(self.panel, for: frame)
            }
        }

        tracker.onTrackingEnded = { [weak self] in
            Task { @MainActor [weak self] in
                self?.closePanel()
            }
        }
    }

    private func observeFrontmostApplication() {
        NSWorkspace.shared.notificationCenter
            .publisher(for: NSWorkspace.didActivateApplicationNotification)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateFrontmostAppState()
            }
            .store(in: &cancellables)
    }

    private func closeOtherActivePanelIfNeeded() {
        if let activeController = Self.activeController, activeController !== self {
            activeController.closePanel()
        }
    }

    private func presentPanel(_ panel: FloatingDropPanel?, for settingsFrame: CGRect) {
        guard let panel else { return }

        if let sourceFrame = pendingLaunchSourceFrame {
            panel.present(from: sourceFrame, to: settingsFrame)
            pendingLaunchSourceFrame = nil
        } else {
            panel.snap(to: settingsFrame)
        }
    }

    private func updateFrontmostAppState() {
        isSettingsFrontmost =
            NSWorkspace.shared.frontmostApplication?.bundleIdentifier == systemSettingsBundleIdentifier
    }
}

@available(macOS 13.0, *)
private extension Array where Element == URL {
    /// Normalizes and de-duplicates `.app` bundle URLs.
    func uniqueAppURLs() -> [URL] {
        var seen = Set<String>()
        return compactMap { url in
            let normalized = url.standardizedFileURL
            guard normalized.pathExtension.lowercased() == "app" else { return nil }
            return seen.insert(normalized.path).inserted ? normalized : nil
        }
    }

    /// Uses normalized file paths for containment because equivalent file URLs
    /// can differ in their string representation.
    func contains(_ url: URL) -> Bool {
        contains(where: { $0.standardizedFileURL.path == url.standardizedFileURL.path })
    }
}
#endif
