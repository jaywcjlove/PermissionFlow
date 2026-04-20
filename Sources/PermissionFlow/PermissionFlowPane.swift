#if os(macOS)
import Foundation
import SystemSettingsKit

@available(macOS 13.0, *)
public enum PermissionFlowPane: String, CaseIterable, Codable, Sendable {
    /// App Management permissions list.
    case appManagement
    /// Accessibility permissions list.
    case accessibility
    /// Bluetooth permissions list.
    case bluetooth
    /// Developer Tools permissions list.
    case developerTools
    /// Full Disk Access permissions list.
    case fullDiskAccess
    /// Input Monitoring permissions list.
    case inputMonitoring
    /// Media & Apple Music permissions list.
    case mediaAppleMusic
    /// Screen Recording permissions list.
    case screenRecording

    /// The matching typed Privacy & Security anchor in SystemSettingsKit.
    public var privacyAnchor: PrivacySecurityAnchor {
        switch self {
        case .appManagement: .privacyAppBundles
        case .accessibility: .privacyAccessibility
        case .bluetooth: .privacyBluetooth
        case .developerTools: .privacyDevTools
        case .fullDiskAccess: .privacyAllFiles
        case .inputMonitoring: .privacyListenEvent
        case .mediaAppleMusic: .privacyMedia
        case .screenRecording: .privacyScreenCapture
        }
    }

    /// Deep link to the corresponding page inside System Settings.
    public var settingsURL: URL {
        SystemSettingsDestination.privacy(anchor: privacyAnchor).url
    }
}
#endif
