#if os(macOS)
import Foundation
import PermissionFlow

@available(macOS 13.0, *)
public enum PermissionFlowScreenRecordingStatus {
    @MainActor
    public static func register() {
        PermissionStatusRegistry.register(
            provider: ScreenRecordingPermissionStatusProvider(),
            for: .screenRecording
        )
    }
}
#endif
