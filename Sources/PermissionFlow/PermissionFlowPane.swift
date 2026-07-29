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
    /// Calendars permissions list.
    ///
    /// Requires calendar usage description keys in the host `Info.plist`.
    /// Does not use the floating drag panel; opens System Settings only.
    case calendars
    /// Developer Tools permissions list.
    case developerTools
    /// Full Disk Access permissions list.
    case fullDiskAccess
    /// Input Monitoring permissions list.
    case inputMonitoring
    /// Media & Apple Music permissions list.
    case mediaAppleMusic
    /// Microphone permissions list.
    case microphone
    /// Reminders permissions list.
    ///
    /// Requires reminders usage description keys in the host `Info.plist`.
    /// Does not use the floating drag panel; opens System Settings only.
    case reminders
    /// Screen Recording permissions list.
    case screenRecording

    /// The matching typed Privacy & Security anchor in SystemSettingsKit.
    public var privacyAnchor: PrivacySecurityAnchor {
        switch self {
        case .appManagement: .privacyAppBundles
        case .accessibility: .privacyAccessibility
        case .bluetooth: .privacyBluetooth
        case .calendars: .privacyCalendars
        case .developerTools: .privacyDevTools
        case .fullDiskAccess: .privacyAllFiles
        case .inputMonitoring: .privacyListenEvent
        case .mediaAppleMusic: .privacyMedia
        case .microphone: .privacyMicrophone
        case .reminders: .privacyReminders
        case .screenRecording: .privacyScreenCapture
        }
    }

    /// Whether this pane supports the app-list drag authorization panel.
    public var supportsFloatingAuthorizationPanel: Bool {
        switch self {
        case .calendars, .microphone, .reminders:
            false
        default:
            true
        }
    }

    /// Deep link to the corresponding page inside System Settings.
    public var settingsURL: URL {
        SystemSettingsDestination.privacy(anchor: privacyAnchor).url
    }

    /// Returns the localized permission name for the requested locale.
    func localizedTitle(localeIdentifier: String?) -> String {
        switch self {
        case .appManagement:
            return PermissionFlowLocalizer.string(
                "permission_flow.pane.app_management",
                defaultValue: "App Management",
                localeIdentifier: localeIdentifier
            )
        case .accessibility:
            return PermissionFlowLocalizer.string(
                "permission_flow.pane.accessibility",
                defaultValue: "Accessibility",
                localeIdentifier: localeIdentifier
            )
        case .bluetooth:
            return PermissionFlowLocalizer.string(
                "permission_flow.pane.bluetooth",
                defaultValue: "Bluetooth",
                localeIdentifier: localeIdentifier
            )
        case .calendars:
            return PermissionFlowLocalizer.string(
                "permission_flow.pane.calendars",
                defaultValue: "Calendars",
                localeIdentifier: localeIdentifier
            )
        case .developerTools:
            return PermissionFlowLocalizer.string(
                "permission_flow.pane.developer_tools",
                defaultValue: "Developer Tools",
                localeIdentifier: localeIdentifier
            )
        case .fullDiskAccess:
            return PermissionFlowLocalizer.string(
                "permission_flow.pane.full_disk_access",
                defaultValue: "Full Disk Access",
                localeIdentifier: localeIdentifier
            )
        case .inputMonitoring:
            return PermissionFlowLocalizer.string(
                "permission_flow.pane.input_monitoring",
                defaultValue: "Input Monitoring",
                localeIdentifier: localeIdentifier
            )
        case .mediaAppleMusic:
            return PermissionFlowLocalizer.string(
                "permission_flow.pane.media_apple_music",
                defaultValue: "Media & Apple Music",
                localeIdentifier: localeIdentifier
            )
        case .microphone:
            return PermissionFlowLocalizer.string(
                "permission_flow.pane.microphone",
                defaultValue: "Microphone",
                localeIdentifier: localeIdentifier
            )
        case .reminders:
            return PermissionFlowLocalizer.string(
                "permission_flow.pane.reminders",
                defaultValue: "Reminders",
                localeIdentifier: localeIdentifier
            )
        case .screenRecording:
            return PermissionFlowLocalizer.string(
                "permission_flow.pane.screen_recording",
                defaultValue: "Screen Recording",
                localeIdentifier: localeIdentifier
            )
        }
    }
}
#endif
