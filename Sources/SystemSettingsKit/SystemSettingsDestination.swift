import Foundation
#if os(iOS)
import UIKit
#endif

#if os(macOS)
@available(macOS 13.0, *)
public enum DisplaySettingsAnchor: String, CaseIterable, Sendable {
    case advancedSection
    case ambienceSection
    case arrangementSection
    case characteristicSection
    case displaysSection
    case miscellaneousSection
    case nightShiftSection
    case profileSection
    case resolutionSection
    case sidecarSection
}

@available(macOS 13.0, *)
public enum PrivacySecurityAnchor: String, CaseIterable, Sendable {
    case advanced = "Advanced"
    case fileVault = "FileVault"
    case locationAccessReport = "Location_Access_Report"
    case lockdownMode = "LockdownMode"
    case privacyAccessibility = "Privacy_Accessibility"
    case privacyAdvertising = "Privacy_Advertising"
    case privacyAllFiles = "Privacy_AllFiles"
    case privacyAnalytics = "Privacy_Analytics"
    case privacyAppBundles = "Privacy_AppBundles"
    case privacyAudioCapture = "Privacy_AudioCapture"
    case privacyAutomation = "Privacy_Automation"
    case privacyBluetooth = "Privacy_Bluetooth"
    case privacyCalendars = "Privacy_Calendars"
    case privacyCamera = "Privacy_Camera"
    case privacyContacts = "Privacy_Contacts"
    case privacyDevTools = "Privacy_DevTools"
    case privacyFilesAndFolders = "Privacy_FilesAndFolders"
    case privacyFocus = "Privacy_Focus"
    case privacyHomeKit = "Privacy_HomeKit"
    case privacyListenEvent = "Privacy_ListenEvent"
    case privacyLocationServices = "Privacy_LocationServices"
    case privacyMedia = "Privacy_Media"
    case privacyMicrophone = "Privacy_Microphone"
    case privacyMotion = "Privacy_Motion"
    case privacyNudityDetection = "Privacy_NudityDetection"
    case privacyPasskeyAccess = "Privacy_PasskeyAccess"
    case privacyPhotos = "Privacy_Photos"
    case privacyReminders = "Privacy_Reminders"
    case privacyRemoteDesktop = "Privacy_RemoteDesktop"
    case privacyScreenCapture = "Privacy_ScreenCapture"
    case privacySpeechRecognition = "Privacy_SpeechRecognition"
    case privacySystemServices = "Privacy_SystemServices"
    case security = "Security"
    case securityImprovements = "SecurityImprovements"
}
#endif

@available(macOS 13.0, iOS 16.0, *)
public struct SystemSettingsDestination: Hashable, Sendable {
    public let url: URL

    /// The pane or extension identifier used by System Settings when the
    /// destination is backed by a macOS deeplink.
    public let paneIdentifier: String?

    /// Optional anchor for a subsection inside a macOS pane.
    public let anchor: String?

    public init(url: URL, paneIdentifier: String? = nil, anchor: String? = nil) {
        self.url = url
        self.paneIdentifier = paneIdentifier
        self.anchor = anchor
    }
}

#if os(macOS)
@available(macOS 13.0, *)
public extension SystemSettingsDestination {
    init(paneIdentifier: String, anchor: String? = nil) {
        let encodedAnchor = anchor?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let value = if let encodedAnchor, encodedAnchor.isEmpty == false {
            "x-apple.systempreferences:\(paneIdentifier)?\(encodedAnchor)"
        } else {
            "x-apple.systempreferences:\(paneIdentifier)"
        }

        self.init(
            url: URL(string: value)!,
            paneIdentifier: paneIdentifier,
            anchor: anchor
        )
    }
}

@available(macOS 13.0, *)
public extension SystemSettingsDestination {
    /// Convenience helper for the Privacy & Security extension anchors.
    /// Example anchors include `Privacy_Advertising` and `Privacy_AllFiles`.
    static func privacy(anchor: String) -> Self {
        Self(
            paneIdentifier: "com.apple.settings.PrivacySecurity.extension",
            anchor: anchor
        )
    }

    /// Convenience helper for typed Privacy & Security anchors.
    static func privacy(anchor: PrivacySecurityAnchor) -> Self {
        Self(
            paneIdentifier: "com.apple.settings.PrivacySecurity.extension",
            anchor: anchor.rawValue
        )
    }

    /// Wallpaper settings.
    static let wallpaper = Self(paneIdentifier: "com.apple.Wallpaper-Settings.extension")

    /// Displays settings.
    static let displays = Self(paneIdentifier: "com.apple.Displays-Settings.extension")

    /// Displays settings subsection.
    static func displays(anchor: DisplaySettingsAnchor) -> Self {
        Self(
            paneIdentifier: "com.apple.Displays-Settings.extension",
            anchor: anchor.rawValue
        )
    }

    /// Bluetooth settings.
    static let bluetooth = Self(paneIdentifier: "com.apple.BluetoothSettings")

    /// Login items settings.
    static let loginItems = Self(paneIdentifier: "com.apple.LoginItems-Settings.extension")
}
#elseif os(iOS)
@available(iOS 16.0, *)
public extension SystemSettingsDestination {
    /// Opens the current app's Settings screen on iOS.
    static let appSettings = Self(url: URL(string: UIApplication.openSettingsURLString)!)

    /// Opens the current app's notification settings screen on iOS.
    static let notificationSettings = Self(url: URL(string: UIApplication.openNotificationSettingsURLString)!)
}
#endif
