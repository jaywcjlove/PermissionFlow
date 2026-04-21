#if os(macOS)
import Foundation
import PermissionFlow

@available(macOS 13.0, *)
public enum PermissionFlowMediaStatus {
    @MainActor
    public static func register() {
        PermissionStatusRegistry.register(
            provider: MediaAppleMusicPermissionStatusProvider(),
            for: .mediaAppleMusic
        )
    }
}
#endif
