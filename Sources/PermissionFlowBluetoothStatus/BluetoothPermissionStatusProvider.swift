#if os(macOS)
import CoreBluetooth
import Foundation
import PermissionFlow

@available(macOS 13.0, *)
public struct BluetoothPermissionStatusProvider: PermissionStatusProviding {
    public var capability: PermissionStatusCapability { .preflightSupported }

    public func authorizationState() -> PermissionAuthorizationState {
        switch CBManager.authorization {
        case .allowedAlways:
            .granted
        case .denied, .restricted, .notDetermined:
            .notGranted
        @unknown default:
            .unknown
        }
    }

    public init() {}
}
#endif
