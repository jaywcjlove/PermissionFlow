#if os(macOS)
import Foundation
import PermissionFlowBluetoothStatus
import PermissionFlowInputMonitoringStatus
import PermissionFlowMediaStatus
import PermissionFlowScreenRecordingStatus

@available(macOS 13.0, *)
public enum PermissionFlowExtendedStatus {
    @MainActor
    public static func register() {
        PermissionFlowBluetoothStatus.register()
        PermissionFlowInputMonitoringStatus.register()
        PermissionFlowMediaStatus.register()
        PermissionFlowScreenRecordingStatus.register()
    }
}
#endif
