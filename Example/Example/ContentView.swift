//
//  ContentView.swift
//  Example
//
//  Created by wong on 4/17/26.
//

import SandboxDrop
import SwiftUI

struct ContentView: View {
    private let demoItems: [PermissionDemoItem] = [
        .init(
            pane: .accessibility,
            subtitle: "辅助功能授权，用于窗口跟随和界面联动。"
        ),
        .init(
            pane: .automation,
            subtitle: "自动化授权，适合需要控制其他应用的场景。"
        ),
        .init(
            pane: .camera,
            subtitle: "摄像头授权示例。"
        ),
        .init(
            pane: .filesAndFolders,
            subtitle: "文件与文件夹访问授权示例。"
        ),
        .init(
            pane: .fullDiskAccess,
            subtitle: "完全磁盘访问授权示例。"
        ),
        .init(
            pane: .inputMonitoring,
            subtitle: "输入监控授权示例。"
        ),
        .init(
            pane: .microphone,
            subtitle: "麦克风授权示例。"
        ),
        .init(
            pane: .screenRecording,
            subtitle: "屏幕录制授权示例。"
        )
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    heroSection
                    LazyVGrid(
                        columns: [
                            GridItem(.adaptive(minimum: 280, maximum: 360), spacing: 16)
                        ],
                        spacing: 16
                    ) {
                        ForEach(demoItems) { item in
                            PermissionCard(item: item)
                        }
                    }
                }
                .padding(24)
            }
            .frame(minWidth: 920, minHeight: 720)
            .navigationTitle("SandboxDrop Demo")
        }
    }

    private var heroSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("macOS 权限授权演示")
                .font(.system(size: 32, weight: .bold, design: .rounded))
            Text("每个按钮都会打开对应的系统设置隐私页。仅支持拖拽添加应用的权限页才会显示悬浮授权窗口，默认建议拖入当前 Example.app。")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
            Text("自动化、摄像头、麦克风、文件与文件夹这类系统原生不支持拖拽添加应用的权限页，只会打开设置界面，不显示悬浮框。")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.secondary.opacity(0.22), in: Capsule())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.09, green: 0.24, blue: 0.40),
                            Color(red: 0.17, green: 0.46, blue: 0.66)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.primary.opacity(0.24), lineWidth: 1)
        )
        .foregroundStyle(.white)
    }
}

private struct PermissionCard: View {
    let item: PermissionDemoItem

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                Image(systemName: item.symbolName)
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 36, height: 36)
                    .background(item.tint.opacity(0.14), in: RoundedRectangle(cornerRadius: 12))
                    .foregroundStyle(item.tint)
                Spacer()
                Text(item.pane.displayName)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)
            }

            Text(item.title)
                .font(.system(size: 20, weight: .semibold))

            Text(item.subtitle)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            SandboxDropButton(
                title: "打开 \(item.pane.displayName)",
                pane: item.pane,
                suggestedAppURLs: [demoAppURL]
            )
            .buttonStyle(.borderedProminent)
            .tint(item.tint)

            Text(item.supportsFloatingPanel ? "支持拖拽添加：\(demoAppURL.lastPathComponent)" : "此权限页仅打开系统设置")
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.primary.opacity(0.08), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.06), radius: 20, y: 8)
    }

    private var demoAppURL: URL {
        Bundle.main.bundleURL
    }
}

private struct PermissionDemoItem: Identifiable {
    let pane: SandboxPermissionPane
    let subtitle: String

    var id: String { pane.rawValue }

    var title: String {
        switch pane {
        case .accessibility: "辅助功能"
        case .automation: "自动化"
        case .camera: "摄像头"
        case .filesAndFolders: "文件与文件夹"
        case .fullDiskAccess: "完全磁盘访问"
        case .inputMonitoring: "输入监控"
        case .microphone: "麦克风"
        case .screenRecording: "屏幕录制"
        }
    }

    var symbolName: String {
        switch pane {
        case .accessibility: "figure.wave"
        case .automation: "apple.terminal.on.rectangle"
        case .camera: "camera"
        case .filesAndFolders: "folder"
        case .fullDiskAccess: "externaldrive"
        case .inputMonitoring: "keyboard"
        case .microphone: "mic"
        case .screenRecording: "display"
        }
    }

    var tint: Color {
        switch pane {
        case .accessibility: .blue
        case .automation: .orange
        case .camera: .pink
        case .filesAndFolders: .teal
        case .fullDiskAccess: .indigo
        case .inputMonitoring: .mint
        case .microphone: .red
        case .screenRecording: .green
        }
    }

    var supportsFloatingPanel: Bool {
        switch pane {
        case .accessibility, .fullDiskAccess, .inputMonitoring, .screenRecording:
            true
        case .automation, .camera, .filesAndFolders, .microphone:
            false
        }
    }
}

#Preview {
    ContentView()
}
