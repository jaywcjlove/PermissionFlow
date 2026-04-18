import AppKit

@available(macOS 13.0, *)
public struct SandboxDropConfiguration: Sendable {
    /// Apps that should already appear in the floating panel.
    public var requiredAppURLs: [URL]

    /// Base panel size before it is resized to match the System Settings
    /// content area width.
    public var panelSize: CGSize

    /// Preserved for API compatibility. The current implementation keeps the
    /// panel tight to the bottom edge of the System Settings window.
    public var topInset: CGFloat

    /// When enabled, tracking can prompt for Accessibility access so AX-based
    /// window observation becomes available immediately.
    public var promptForAccessibilityTrust: Bool

    public init(
        requiredAppURLs: [URL] = [],
        panelSize: CGSize = CGSize(width: 420, height: 320),
        topInset: CGFloat = 18,
        promptForAccessibilityTrust: Bool = false
    ) {
        self.requiredAppURLs = requiredAppURLs
        self.panelSize = panelSize
        self.topInset = topInset
        self.promptForAccessibilityTrust = promptForAccessibilityTrust
    }
}
