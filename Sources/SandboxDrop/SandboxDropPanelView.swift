import SwiftUI

@available(macOS 13.0, *)
struct SandboxDropPanelView: View {
    @ObservedObject var controller: SandboxDropController

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            header
            if let primaryApp = controller.preferredAppURL {
                AppDragItemView(url: primaryApp) { isDragging in
                    controller.setPanelDragging(isDragging)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.top, 8)
        .padding(.bottom, 12)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .fixedSize(horizontal: false, vertical: true)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(.primary.opacity(0.14), lineWidth: 1)
                )
        )
    }

    /// Keeps the header logic isolated from the drag card layout.
    private var header: some View {
        HStack(alignment: .top) {
            Text(controller.currentPane?.displayName ?? "Sandbox Permission")
                .font(.system(size: 17, weight: .semibold))

            Spacer()

            if controller.isSettingsFrontmost == false {
                Button {
                    controller.reopenCurrentSettingsPane()
                } label: {
                    Image(systemName: "gear")
                        .font(.system(size: 14, weight: .semibold))
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.primary, .secondary.opacity(0.35))
                }
                .buttonStyle(.borderless)
            }

            Button {
                controller.closePanel()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.primary, .secondary.opacity(0.35))
            }
            .buttonStyle(.borderless)
        }
    }
}
