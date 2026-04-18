import AppKit

@available(macOS 13.0, *)
@MainActor
final class SettingsNavigator {
    private let bundleIdentifier = "com.apple.systempreferences"
    private let applicationURL = URL(fileURLWithPath: "/System/Applications/System Settings.app")

    /// Opens System Settings, jumps to the requested privacy pane, and brings
    /// the app forward so the floating panel can align to the correct window.
    func openSettings(for pane: SandboxPermissionPane) {
        NSWorkspace.shared.openApplication(
            at: applicationURL,
            configuration: NSWorkspace.OpenConfiguration()
        ) { _, _ in }

        NSWorkspace.shared.open(pane.settingsURL)
        activateSettings()
    }

    /// Re-activates the running System Settings process if it already exists.
    func activateSettings() {
        NSRunningApplication.runningApplications(withBundleIdentifier: bundleIdentifier)
            .first?
            .activate(options: [.activateIgnoringOtherApps])
    }
}
