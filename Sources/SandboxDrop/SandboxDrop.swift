@available(macOS 13.0, *)
public enum SandboxDrop {
    /// Creates the object that owns System Settings navigation, window
    /// tracking, and the floating drag panel lifecycle.
    @MainActor
    public static func makeController(
        configuration: SandboxDropConfiguration = .init()
    ) -> SandboxDropController {
        SandboxDropController(configuration: configuration)
    }
}
