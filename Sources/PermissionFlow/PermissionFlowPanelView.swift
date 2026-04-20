#if os(macOS)
import AppKit
import SwiftUI

@available(macOS 13.0, *)
struct PermissionFlowPanelView: View {
    @ObservedObject var controller: PermissionFlowController
    @State private var isArrowLifted = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color(nsColor: .windowBackgroundColor).opacity(0.78))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color(nsColor: .separatorColor).opacity(0.18), lineWidth: 0.5)
                )

            header
                .padding(.top, 10)
                .padding(.leading, 35)
                .padding(.trailing, 22)

            bottomRow
                .padding(.top, 47)
                .padding(.leading, 18)
                .padding(.trailing, 21)
        }
        .frame(width: 530, height: 109, alignment: .topLeading)
    }

    private var bottomRow: some View {
        HStack(spacing: 14) {
            backButton
            if let primaryApp = controller.preferredAppURL {
                AppDragItemView(url: primaryApp) { isDragging in
                    controller.setPanelDragging(isDragging)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 43)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var backButton: some View {
        Button {
            controller.returnToHostApplication()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color(nsColor: .labelColor).opacity(0.72))
                .frame(width: 14, height: 14)
                .frame(width: 32, height: 32)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(nsColor: .controlBackgroundColor).opacity(0.95))
                )
        }
        .buttonStyle(.plain)
    }

    private var header: some View {
        HStack(spacing: 10) {
            Image(systemName: "arrow.up")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(Color(red: 0.15, green: 0.54, blue: 0.98))
                .offset(y: isArrowLifted ? -7 : 0)
                .animation(
                    .easeInOut(duration: 0.85).repeatForever(autoreverses: true),
                    value: isArrowLifted
                )
                .onAppear {
                    isArrowLifted = true
                }

            Text(instructionText)
                .font(.system(size: 14))
                .foregroundStyle(Color(nsColor: .labelColor).opacity(0.82))
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }

    private var instructionText: AttributedString {
        let appName = controller.preferredAppURL?
            .deletingPathExtension()
            .lastPathComponent ?? appDisplayNameFallback
        let paneTitle = controller.currentPane?.title ?? "this permission"
        let format = String(
            localized: "Drag **%@** to the list above to allow **%@**",
            bundle: .module,
            comment: "PermissionFlow helper panel instruction. First placeholder is app name, second is permission title. Keep markdown ** ** around placeholders to make them bold."
        )
        let markdown = String(format: format, locale: .current, appName, paneTitle)
        return (try? AttributedString(markdown: markdown))
            ?? AttributedString("Drag \(appName) to the list above to allow \(paneTitle)")
    }

    private var appDisplayNameFallback: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
            ?? Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
            ?? "this app"
    }
}
#endif
