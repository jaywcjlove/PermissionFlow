#if os(macOS)
import Foundation
import PermissionFlow

@available(macOS 13.0, *)
public enum PermissionFlowCameraStatus {
    @MainActor
    public static func register() {
        PermissionStatusRegistry.register(
            provider: CameraPermissionStatusProvider(),
            for: .camera
        )
    }
}
#endif
