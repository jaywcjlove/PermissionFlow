#if os(macOS)
import AVFoundation
import Foundation
import PermissionFlow

@available(macOS 13.0, *)
public struct ScreenRecordingPermissionStatusProvider: PermissionStatusProviding {
    public var capability: PermissionStatusCapability { .preflightSupported }

    public func authorizationState() -> PermissionAuthorizationState {
        let isGranted = CGPreflightScreenCaptureAccess()
        return isGranted ? .granted : .notGranted
    }

    public init() {}
}
#endif
