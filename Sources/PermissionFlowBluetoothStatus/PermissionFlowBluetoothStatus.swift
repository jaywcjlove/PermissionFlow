#if os(macOS)
import Foundation
import PermissionFlow

@available(macOS 13.0, *)
public enum PermissionFlowBluetoothStatus {
    @MainActor
    public static func register() {
        PermissionStatusRegistry.register(
            provider: BluetoothPermissionStatusProvider(),
            for: .bluetooth
        )
    }
}
#endif
