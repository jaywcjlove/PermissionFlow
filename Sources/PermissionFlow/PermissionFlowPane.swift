#if os(macOS)
import Foundation

@available(macOS 13.0, *)
public enum PermissionFlowPane: String, CaseIterable, Codable, Sendable {
    /// Accessibility permissions list.
    case accessibility = "Privacy_Accessibility"
    /// Full Disk Access permissions list.
    case fullDiskAccess = "Privacy_AllFiles"
    /// Input Monitoring permissions list.
    case inputMonitoring = "Privacy_ListenEvent"
    /// Screen Recording permissions list.
    case screenRecording = "Privacy_ScreenCapture"

    /// Deep link to the corresponding page inside System Settings.
    public var settingsURL: URL {
        URL(string: "x-apple.systempreferences:com.apple.preference.security?\(rawValue)")!
    }
}
#endif
