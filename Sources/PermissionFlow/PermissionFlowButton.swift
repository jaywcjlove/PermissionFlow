#if os(macOS)
import AppKit
import SwiftUI

@available(macOS 13.0, *)
public struct PermissionFlowButton: View {
    @Environment(\.locale) var locale
    @StateObject private var controller: PermissionFlowController
    @State private var buttonState: PermissionFlowButtonState
    private let pane: PermissionFlowPane
    private let suggestedAppURLs: [URL]
    private let title: LocalizedStringResource?
    private let customLabel: ((PermissionFlowButtonState) -> AnyView)?

    public init(
        title: LocalizedStringResource? = nil,
        pane: PermissionFlowPane,
        suggestedAppURLs: [URL] = [],
        configuration: PermissionFlowConfiguration = .init()
    ) {
        _controller = StateObject(wrappedValue: PermissionFlowController(configuration: configuration))
        self.pane = pane
        self.suggestedAppURLs = suggestedAppURLs
        self.title = title
        self.customLabel = nil
        
        // Initialize with checking state, will be updated on appear
        _buttonState = State(initialValue: PermissionFlowButtonState.make(from: .checking))
    }

    public init<Label: View>(
        pane: PermissionFlowPane,
        suggestedAppURLs: [URL] = [],
        configuration: PermissionFlowConfiguration = .init(),
        @ViewBuilder label: @escaping (PermissionFlowButtonState) -> Label
    ) {
        _controller = StateObject(wrappedValue: PermissionFlowController(configuration: configuration))
        self.pane = pane
        self.suggestedAppURLs = suggestedAppURLs
        self.title = nil
        self.customLabel = { AnyView(label($0)) }
        
        // Initialize with checking state, will be updated on appear
        _buttonState = State(initialValue: PermissionFlowButtonState.make(from: .checking))
    }

    public var body: some View {
        Button {
            authorize()
        } label: {
            if let customLabel {
                customLabel(buttonState)
            } else {
                Label {
                    buttonTitleLabel
                } icon: {
                    Image(systemName: buttonState.systemImage)
                        .foregroundColor(buttonState.isGranted ? .green : .primary)
                }
            }
        }
        .onAppear(perform: refreshAuthorizationStatus)
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
            refreshAuthorizationStatus()
        }
    }

    /// Resolves package UI copy through the resilient localizer so installed
    /// apps never touch `Bundle.module` during button layout.
    @ViewBuilder
    private var buttonTitleLabel: some View {
        if let title {
            Text(title)
        } else {
            Text(
                PermissionFlowLocalizer.string(
                    buttonState.titleKey,
                    defaultValue: buttonState.defaultTitle,
                    localeIdentifier: locale.identifier
                )
            )
        }
    }

    /// Uses the exact click location as the launch point so the panel appears
    /// to fly out from where the user pressed the button.
    private func clickSourceFrameInScreen() -> CGRect {
        let mouse = NSEvent.mouseLocation
        return CGRect(x: mouse.x - 16, y: mouse.y - 16, width: 32, height: 32)
    }

    private func authorize() {
        controller.setLocaleIdentifier(locale.identifier)

        if pane == .microphone {
            requestMicrophoneAuthorization()
            return
        }

        controller.authorize(
            pane: pane,
            suggestedAppURLs: suggestedAppURLs,
            sourceFrameInScreen: clickSourceFrameInScreen()
        )
    }

    private func requestMicrophoneAuthorization() {
        buttonState = PermissionFlowButtonState.make(from: .checking)
        MicrophonePermissionStatusProvider().requestAuthorization { authorizationState in
            Task { @MainActor in
                buttonState = PermissionFlowButtonState.make(from: authorizationState)
                controller.authorize(pane: .microphone)
            }
        }
    }

    private func refreshAuthorizationStatus() {
        let provider = PermissionStatusRegistry.provider(for: pane)
        let authState = provider.authorizationState()
        buttonState = PermissionFlowButtonState.make(from: authState)
    }
}
#endif
