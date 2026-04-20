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

    /// Human-readable title used by the floating guidance panel.
    public var title: String {
        switch self {
        case .accessibility:
            return String(localized: "Accessibility", bundle: .module)
        case .fullDiskAccess:
            return String(localized: "Full Disk Access", bundle: .module)
        case .inputMonitoring:
            return String(localized: "Input Monitoring", bundle: .module)
        case .screenRecording:
            return String(localized: "Screen Recording", bundle: .module)
        }
    }
}
#endif
