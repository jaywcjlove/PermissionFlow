#if os(macOS)
import Foundation
import PermissionFlow
import StoreKit
#if canImport(MusicKit)
import MusicKit
#endif

@available(macOS 13.0, *)
public struct MediaAppleMusicPermissionStatusProvider: PermissionStatusProviding {
    public var capability: PermissionStatusCapability { .preflightSupported }

    public func authorizationState() -> PermissionAuthorizationState {
        #if canImport(MusicKit)
        switch MusicAuthorization.currentStatus {
        case .authorized:
            return .granted
        case .denied, .restricted, .notDetermined:
            return .notGranted
        @unknown default:
            return .unknown
        }
        #else
        switch SKCloudServiceController.authorizationStatus() {
        case .authorized:
            return .granted
        case .denied, .restricted, .notDetermined:
            return .notGranted
        @unknown default:
            return .unknown
        }
        #endif
    }

    public init() {}
}
#endif
