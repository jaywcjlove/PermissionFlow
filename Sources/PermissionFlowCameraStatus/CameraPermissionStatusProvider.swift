#if os(macOS)
import AVFoundation
import Foundation
import PermissionFlow

@available(macOS 13.0, *)
public struct CameraPermissionStatusProvider: PermissionStatusProviding {
    public var capability: PermissionStatusCapability { .preflightSupported }

    public func authorizationState() -> PermissionAuthorizationState {
        Self.authorizationState(for: AVCaptureDevice.authorizationStatus(for: .video))
    }

    /// Requests camera access when undetermined, then reports the resulting state.
    ///
    /// Host apps must:
    /// 1. Declare `NSCameraUsageDescription` in `Info.plist`.
    /// 2. If App Sandbox is enabled, turn on Camera access
    ///    (`com.apple.security.device.camera` /
    ///    `ENABLE_RESOURCE_ACCESS_CAMERA = YES`).
    ///
    /// After a successful first request the app appears in
    /// System Settings > Privacy & Security > Camera.
    public func requestAuthorization(
        completion: @escaping @Sendable (PermissionAuthorizationState) -> Void
    ) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                completion(granted ? .granted : .notGranted)
            }
        case let status:
            completion(Self.authorizationState(for: status))
        }
    }

    public init() {}

    private static func authorizationState(
        for status: AVAuthorizationStatus
    ) -> PermissionAuthorizationState {
        switch status {
        case .authorized:
            .granted
        case .denied, .restricted, .notDetermined:
            .notGranted
        @unknown default:
            .unknown
        }
    }
}
#endif
