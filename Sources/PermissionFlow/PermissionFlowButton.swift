#if os(macOS)
import SwiftUI

@available(macOS 13.0, *)
public struct PermissionFlowButton: View {
    @StateObject private var controller: PermissionFlowController
    private let pane: PermissionFlowPane
    private let suggestedAppURLs: [URL]
    private let title: String

    public init(
        title: String = "授权",
        pane: PermissionFlowPane,
        suggestedAppURLs: [URL] = [],
        configuration: PermissionFlowConfiguration = .init()
    ) {
        _controller = StateObject(wrappedValue: PermissionFlowController(configuration: configuration))
        self.pane = pane
        self.suggestedAppURLs = suggestedAppURLs
        self.title = title
    }

    public var body: some View {
        Button(title) {
            controller.authorize(
                pane: pane,
                suggestedAppURLs: suggestedAppURLs,
                sourceFrameInScreen: clickSourceFrameInScreen()
            )
        }
    }

    /// Uses the exact click location as the launch point so the panel appears
    /// to fly out from where the user pressed the button.
    private func clickSourceFrameInScreen() -> CGRect {
        let mouse = NSEvent.mouseLocation
        return CGRect(x: mouse.x - 16, y: mouse.y - 16, width: 32, height: 32)
    }
}
#endif
