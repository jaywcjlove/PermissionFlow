#if os(macOS)
import Carbon
import Foundation
import PermissionFlow

@available(macOS 13.0, *)
public struct InputMonitoringPermissionStatusProvider: PermissionStatusProviding {
    public var capability: PermissionStatusCapability { .preflightSupported }

    public func authorizationState() -> PermissionAuthorizationState {
        let isGranted = CGPreflightListenEventAccess()
        return isGranted ? .granted : .notGranted
    }

    public init() {}
}
#endif
