#if os(macOS)
import AppKit

@available(macOS 13.0, *)
public struct PermissionFlowConfiguration: Sendable {
    /// Apps that should already appear in the floating panel.
    public var requiredAppURLs: [URL]

    /// When enabled, tracking can prompt for Accessibility access so AX-based
    /// window observation becomes available immediately.
    public var promptForAccessibilityTrust: Bool

    public init(
        requiredAppURLs: [URL] = [],
        promptForAccessibilityTrust: Bool = false
    ) {
        self.requiredAppURLs = requiredAppURLs
        self.promptForAccessibilityTrust = promptForAccessibilityTrust
    }
}
#endif
