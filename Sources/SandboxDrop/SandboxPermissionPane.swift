import Foundation

@available(macOS 13.0, *)
public enum SandboxPermissionPane: String, CaseIterable, Codable, Sendable {
    /// Accessibility permissions list.
    case accessibility = "Privacy_Accessibility"
    /// Automation permissions list.
    case automation = "Privacy_Automation"
    /// Camera permissions list.
    case camera = "Privacy_Camera"
    /// Files & Folders permissions list.
    case filesAndFolders = "Privacy_FilesAndFolders"
    /// Full Disk Access permissions list.
    case fullDiskAccess = "Privacy_AllFiles"
    /// Input Monitoring permissions list.
    case inputMonitoring = "Privacy_ListenEvent"
    /// Microphone permissions list.
    case microphone = "Privacy_Microphone"
    /// Screen Recording permissions list.
    case screenRecording = "Privacy_ScreenCapture"

    /// Human-readable title shown in the floating panel.
    public var displayName: String {
        switch self {
        case .accessibility: "Accessibility"
        case .automation: "Automation"
        case .camera: "Camera"
        case .filesAndFolders: "Files & Folders"
        case .fullDiskAccess: "Full Disk Access"
        case .inputMonitoring: "Input Monitoring"
        case .microphone: "Microphone"
        case .screenRecording: "Screen Recording"
        }
    }

    /// Only some privacy panes accept dragging an app bundle into a managed
    /// authorization list. The remaining panes should simply open in System
    /// Settings without presenting the floating drag helper.
    var supportsFloatingPanel: Bool {
        switch self {
        case .accessibility, .fullDiskAccess, .inputMonitoring, .screenRecording:
            true
        case .automation, .camera, .filesAndFolders, .microphone:
            false
        }
    }

    /// Deep link to the corresponding page inside System Settings.
    var settingsURL: URL {
        URL(string: "x-apple.systempreferences:com.apple.preference.security?\(rawValue)")!
    }
}
