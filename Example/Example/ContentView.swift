//
//  ContentView.swift
//  Example
//
//  Created by wong on 4/17/26.
//

import SystemSettingsKit
import SwiftUI
#if os(macOS)
import PermissionFlow
#endif

struct ContentView: View {
    var body: some View {
#if os(macOS)
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    heroSection
                    permissionCardsSection
                    settingsURLTestSection
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            .frame(minWidth: 920, minHeight: 720)
            .navigationTitle("PermissionFlow Demo")
        }
#else
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                heroSection
                settingsURLTestSection
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .ignoresSafeArea()
        .frame(maxHeight: .infinity)
        .navigationTitle("PermissionFlow Demo")
#endif
    }

    private var heroSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("PermissionFlow / SystemSettingsKit 示例")
                .font(.system(size: 32, weight: .bold, design: .rounded))
            VStack(alignment: .leading, spacing: 6) {
#if os(macOS)
                Text("每个按钮都会打开对应的系统设置隐私页。仅支持拖拽添加应用的权限页才会显示悬浮授权窗口，默认建议拖入当前 Example.app。")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                Text("自动化、摄像头、麦克风、文件与文件夹这类系统原生不支持拖拽添加应用的权限页，只会打开设置界面，不显示悬浮框。")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.primary)
#else
                Text("当前页面按平台拆分展示。iOS 侧只展示 `SystemSettingsKit` 可用的设置入口；`PermissionFlow` 仅支持 macOS。")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
#endif
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var settingsURLTestSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("System Settings URL 测试")
                    .font(.system(size: 24, weight: .bold))
#if os(macOS)
                Text("下面按平台拆分展示 `SystemSettingsKit` 的能力范围。macOS 区域用于测试 `SystemSettings-URLs-macOS` 风格的 deeplink；iOS 区域展示当前已封装的 iOS 设置入口。")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
#else
                Text("当前页面仅展示 iOS 可用的 `SystemSettingsKit` 示例。macOS 专属的 pane / anchor deeplink 与 `PermissionFlow` 授权引导不会在 iOS 中显示。")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
#endif
            }

#if os(macOS)
            platformSectionHeader(
                title: "macOS 示例",
                subtitle: "面向 `System Settings` 的 pane identifier、anchor 与强类型跳转。"
            )
            settingsURLGroup(
                title: "隐私与安全性",
                buttons: {
                    settingsURLButton(title: "隐私与安全性首页", subtitle: "跳转到 隐私与安全性 首页", symbolName: "lock.shield", tint: .gray) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.settings.PrivacySecurity.extension")) }
                    settingsURLButton(title: "高级", subtitle: "跳转到 隐私与安全性 > 高级", symbolName: "gearshape.2", tint: .gray) { SystemSettings.open(.privacy(anchor: .advanced)) }
                    settingsURLButton(title: "安全性", subtitle: "跳转到 隐私与安全性 > 安全性", symbolName: "shield", tint: .gray) { SystemSettings.open(.privacy(anchor: .security)) }
                    settingsURLButton(title: "安全改进", subtitle: "跳转到 隐私与安全性 > 安全改进", symbolName: "shield.lefthalf.filled.badge.checkmark", tint: .green) { SystemSettings.open(.privacy(anchor: .securityImprovements)) }
                    settingsURLButton(title: "文件保险箱", subtitle: "跳转到 隐私与安全性 > FileVault", symbolName: "lock.rectangle", tint: .blue) { SystemSettings.open(.privacy(anchor: .fileVault)) }
                    settingsURLButton(title: "锁定模式", subtitle: "跳转到 隐私与安全性 > 锁定模式", symbolName: "lock.trianglebadge.exclamationmark", tint: .red) { SystemSettings.open(.privacy(anchor: .lockdownMode)) }
                    settingsURLButton(title: "位置访问报告", subtitle: "跳转到 隐私与安全性 > 位置访问报告", symbolName: "location.viewfinder", tint: .orange) { SystemSettings.open(.privacy(anchor: .locationAccessReport)) }
                    settingsURLButton(title: "广告", subtitle: "跳转到 隐私与安全性 > 广告", symbolName: "megaphone", tint: .orange) { SystemSettings.open(.privacy(anchor: .privacyAdvertising)) }
                    settingsURLButton(title: "辅助功能", subtitle: "跳转到 隐私与安全性 > 辅助功能", symbolName: "figure.wave", tint: .blue) { SystemSettings.open(.privacy(anchor: .privacyAccessibility)) }
                    settingsURLButton(title: "自动化", subtitle: "跳转到 隐私与安全性 > 自动化", symbolName: "apple.terminal.on.rectangle", tint: .brown) { SystemSettings.open(.privacy(anchor: .privacyAutomation)) }
                    settingsURLButton(title: "App 管理", subtitle: "跳转到 隐私与安全性 > App 管理", symbolName: "shippingbox", tint: .brown) { SystemSettings.open(.privacy(anchor: .privacyAppBundles)) }
                    settingsURLButton(title: "分析与改进", subtitle: "跳转到 隐私与安全性 > 分析与改进", symbolName: "chart.bar", tint: .cyan) { SystemSettings.open(.privacy(anchor: .privacyAnalytics)) }
                    settingsURLButton(title: "音频捕获", subtitle: "跳转到 隐私与安全性 > 音频捕获", symbolName: "waveform", tint: .purple) { SystemSettings.open(.privacy(anchor: .privacyAudioCapture)) }
                    settingsURLButton(title: "蓝牙", subtitle: "跳转到 隐私与安全性 > 蓝牙", symbolName: "bolt.horizontal.circle", tint: .blue) { SystemSettings.open(.privacy(anchor: .privacyBluetooth)) }
                    settingsURLButton(title: "日历", subtitle: "跳转到 隐私与安全性 > 日历", symbolName: "calendar", tint: .red) { SystemSettings.open(.privacy(anchor: .privacyCalendars)) }
                    settingsURLButton(title: "摄像头", subtitle: "跳转到 隐私与安全性 > 摄像头", symbolName: "camera", tint: .pink) { SystemSettings.open(.privacy(anchor: .privacyCamera)) }
                    settingsURLButton(title: "联系人", subtitle: "跳转到 隐私与安全性 > 联系人", symbolName: "person.crop.circle.badge.checkmark", tint: .blue) { SystemSettings.open(.privacy(anchor: .privacyContacts)) }
                    settingsURLButton(title: "开发者工具", subtitle: "跳转到 隐私与安全性 > 开发者工具", symbolName: "hammer", tint: .orange) { SystemSettings.open(.privacy(anchor: .privacyDevTools)) }
                    settingsURLButton(title: "文件与文件夹", subtitle: "跳转到 隐私与安全性 > 文件与文件夹", symbolName: "folder", tint: .teal) { SystemSettings.open(.privacy(anchor: .privacyFilesAndFolders)) }
                    settingsURLButton(title: "专注模式", subtitle: "跳转到 隐私与安全性 > 专注模式", symbolName: "moon.circle", tint: .indigo) { SystemSettings.open(.privacy(anchor: .privacyFocus)) }
                    settingsURLButton(title: "家庭", subtitle: "跳转到 隐私与安全性 > 家庭", symbolName: "house", tint: .mint) { SystemSettings.open(.privacy(anchor: .privacyHomeKit)) }
                    settingsURLButton(title: "输入监控", subtitle: "跳转到 隐私与安全性 > 输入监控", symbolName: "keyboard", tint: .mint) { SystemSettings.open(.privacy(anchor: .privacyListenEvent)) }
                    settingsURLButton(title: "定位服务", subtitle: "跳转到 隐私与安全性 > 定位服务", symbolName: "location", tint: .orange) { SystemSettings.open(.privacy(anchor: .privacyLocationServices)) }
                    settingsURLButton(title: "媒体与 Apple Music", subtitle: "跳转到 隐私与安全性 > 媒体与 Apple Music", symbolName: "music.note.list", tint: .red) { SystemSettings.open(.privacy(anchor: .privacyMedia)) }
                    settingsURLButton(title: "麦克风", subtitle: "跳转到 隐私与安全性 > 麦克风", symbolName: "mic", tint: .red) { SystemSettings.open(.privacy(anchor: .privacyMicrophone)) }
                    settingsURLButton(title: "动作与健身", subtitle: "跳转到 隐私与安全性 > 动作与健身", symbolName: "figure.walk", tint: .green) { SystemSettings.open(.privacy(anchor: .privacyMotion)) }
                    settingsURLButton(title: "敏感内容警告", subtitle: "跳转到 隐私与安全性 > 敏感内容警告", symbolName: "exclamationmark.shield", tint: .pink) { SystemSettings.open(.privacy(anchor: .privacyNudityDetection)) }
                    settingsURLButton(title: "钥匙串与通行密钥", subtitle: "跳转到 隐私与安全性 > 通行密钥访问", symbolName: "key", tint: .yellow) { SystemSettings.open(.privacy(anchor: .privacyPasskeyAccess)) }
                    settingsURLButton(title: "照片", subtitle: "跳转到 隐私与安全性 > 照片", symbolName: "photo", tint: .purple) { SystemSettings.open(.privacy(anchor: .privacyPhotos)) }
                    settingsURLButton(title: "提醒事项", subtitle: "跳转到 隐私与安全性 > 提醒事项", symbolName: "list.bullet", tint: .blue) { SystemSettings.open(.privacy(anchor: .privacyReminders)) }
                    settingsURLButton(title: "远程桌面", subtitle: "跳转到 隐私与安全性 > 远程桌面", symbolName: "desktopcomputer.and.arrow.down", tint: .cyan) { SystemSettings.open(.privacy(anchor: .privacyRemoteDesktop)) }
                    settingsURLButton(title: "屏幕录制", subtitle: "跳转到 隐私与安全性 > 屏幕录制", symbolName: "display", tint: .green) { SystemSettings.open(.privacy(anchor: .privacyScreenCapture)) }
                    settingsURLButton(title: "语音识别", subtitle: "跳转到 隐私与安全性 > 语音识别", symbolName: "waveform.badge.mic", tint: .orange) { SystemSettings.open(.privacy(anchor: .privacySpeechRecognition)) }
                    settingsURLButton(title: "系统服务", subtitle: "跳转到 隐私与安全性 > 系统服务", symbolName: "gearshape.2.fill", tint: .gray) { SystemSettings.open(.privacy(anchor: .privacySystemServices)) }
                    settingsURLButton(title: "完全磁盘访问", subtitle: "跳转到 隐私与安全性 > 完全磁盘访问", symbolName: "externaldrive", tint: .indigo) { SystemSettings.open(.privacy(anchor: .privacyAllFiles)) }
                }
            )

            settingsURLGroup(
                title: "常用页面",
                buttons: {
                    settingsURLButton(title: "Apple ID", symbolName: "person.crop.circle", tint: .blue) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.systempreferences.AppleIDSettings")) }
                    settingsURLButton(title: "外观", symbolName: "circle.lefthalf.filled", tint: .gray) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Appearance-Settings.extension")) }
                    settingsURLButton(title: "辅助功能", symbolName: "accessibility", tint: .blue) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Accessibility-Settings.extension")) }
                    settingsURLButton(title: "蓝牙", symbolName: "bolt.horizontal.circle", tint: .blue) { SystemSettings.open(.bluetooth) }
                    settingsURLButton(title: "电池", symbolName: "battery.100", tint: .green) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Battery-Settings.extension")) }
                    settingsURLButton(title: "日期与时间", symbolName: "calendar", tint: .orange) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Date-Time-Settings.extension")) }
                    settingsURLButton(title: "桌面与程序坞", symbolName: "menubar.dock.rectangle", tint: .teal) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Desktop-Settings.extension")) }
                    settingsURLButton(title: "显示器", symbolName: "display.2", tint: .indigo) { SystemSettings.open(.displays) }
                    settingsURLButton(title: "通用", symbolName: "gearshape", tint: .secondary) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.systempreferences.GeneralSettings")) }
                    settingsURLButton(title: "登录项", symbolName: "person.badge.key", tint: .brown) { SystemSettings.open(.loginItems) }
                    settingsURLButton(title: "网络", symbolName: "network", tint: .cyan) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Network-Settings.extension")) }
                    settingsURLButton(title: "密码", symbolName: "key", tint: .yellow) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Passwords")) }
                    settingsURLButton(title: "壁纸", symbolName: "photo.on.rectangle", tint: .purple) { SystemSettings.open(.wallpaper) }
                    settingsURLButton(title: "屏幕保护程序", symbolName: "sparkles.tv", tint: .pink) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Wallpaper-Settings.extension", anchor: "ScreenSaver")) }
                }
            )

            settingsURLGroup(
                title: "显示器子页面",
                buttons: {
                    settingsURLButton(title: "显示器列表", subtitle: "跳转到 显示器 > 显示器列表", symbolName: "rectangle.on.rectangle", tint: .indigo) { SystemSettings.open(.displays(anchor: .displaysSection)) }
                    settingsURLButton(title: "排列", subtitle: "跳转到 显示器 > 排列", symbolName: "square.grid.3x3", tint: .blue) { SystemSettings.open(.displays(anchor: .arrangementSection)) }
                    settingsURLButton(title: "分辨率", subtitle: "跳转到 显示器 > 分辨率", symbolName: "aspectratio", tint: .green) { SystemSettings.open(.displays(anchor: .resolutionSection)) }
                    settingsURLButton(title: "夜览", subtitle: "跳转到 显示器 > 夜览", symbolName: "moon.stars", tint: .orange) { SystemSettings.open(.displays(anchor: .nightShiftSection)) }
                    settingsURLButton(title: "色彩配置文件", subtitle: "跳转到 显示器 > 色彩配置文件", symbolName: "paintpalette", tint: .pink) { SystemSettings.open(.displays(anchor: .profileSection)) }
                    settingsURLButton(title: "Sidecar", subtitle: "跳转到 显示器 > Sidecar", symbolName: "ipad.and.arrow.forward", tint: .mint) { SystemSettings.open(.displays(anchor: .sidecarSection)) }
                    settingsURLButton(title: "高级", subtitle: "跳转到 显示器 > 高级", symbolName: "slider.horizontal.3", tint: .gray) { SystemSettings.open(.displays(anchor: .advancedSection)) }
                    settingsURLButton(title: "氛围显示", subtitle: "跳转到 显示器 > 氛围显示", symbolName: "sparkles", tint: .purple) { SystemSettings.open(.displays(anchor: .ambienceSection)) }
                    settingsURLButton(title: "显示特性", subtitle: "跳转到 显示器 > 显示特性", symbolName: "dial.medium", tint: .teal) { SystemSettings.open(.displays(anchor: .characteristicSection)) }
                    settingsURLButton(title: "其他", subtitle: "跳转到 显示器 > 其他", symbolName: "ellipsis.circle", tint: .secondary) { SystemSettings.open(.displays(anchor: .miscellaneousSection)) }
                }
            )

            settingsURLGroup(
                title: "系统与高级页面",
                buttons: {
                    settingsURLButton(title: "隔空投送与接力", symbolName: "handoff", tint: .mint) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.AirDrop-Handoff-Settings.extension")) }
                    settingsURLButton(title: "CD 与 DVD", symbolName: "opticaldiscdrive", tint: .orange) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.CD-DVD-Settings.extension")) }
                    settingsURLButton(title: "保障范围", symbolName: "checkmark.shield", tint: .green) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Coverage-Settings.extension")) }
                    settingsURLButton(title: "家人共享", symbolName: "person.3", tint: .pink) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Family-Settings.extension")) }
                    settingsURLButton(title: "后续事项", symbolName: "list.bullet.clipboard", tint: .orange) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.FollowUpSettings.FollowUpSettingsExtension")) }
                    settingsURLButton(title: "耳机", symbolName: "headphones", tint: .indigo) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.HeadphoneSettings")) }
                    settingsURLButton(title: "语言与地区", symbolName: "globe", tint: .blue) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Localization-Settings.extension")) }
                    settingsURLButton(title: "描述文件", symbolName: "doc.badge.gearshape", tint: .brown) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Profiles-Settings.extension")) }
                    settingsURLButton(title: "共享", symbolName: "square.and.arrow.up.on.square", tint: .teal) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Sharing-Settings.extension")) }
                    settingsURLButton(title: "软件更新", symbolName: "arrow.down.circle", tint: .green) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Software-Update-Settings.extension")) }
                    settingsURLButton(title: "启动磁盘", symbolName: "internaldrive", tint: .gray) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Startup-Disk-Settings.extension")) }
                    settingsURLButton(title: "储存空间", symbolName: "externaldrive.fill.badge.person.crop", tint: .indigo) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.settings.Storage")) }
                    settingsURLButton(title: "时光机器", symbolName: "clock.arrow.trianglehead.counterclockwise.rotate.90", tint: .mint) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Time-Machine-Settings.extension")) }
                    settingsURLButton(title: "Touch ID", symbolName: "touchid", tint: .primary) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Touch-ID-Settings.extension")) }
                    settingsURLButton(title: "传输或还原", symbolName: "arrow.triangle.2.circlepath", tint: .red) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Transfer-Reset-Settings.extension")) }
                    settingsURLButton(title: "用户与群组", symbolName: "person.2", tint: .cyan) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Users-Groups-Settings.extension")) }
                    settingsURLButton(title: "关于本机", symbolName: "info.circle", tint: .blue) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.SystemProfiler.AboutExtension")) }
                }
            )
#endif

            platformSectionHeader(
                title: "iOS 示例",
                subtitle: "当前 `SystemSettingsKit` 在 iOS 侧只封装 UIKit 公开支持的设置入口。这里分别展示当前 App 设置页和通知设置页。"
            )
            settingsURLGroup(
                title: "当前 App 设置页",
                buttons: {
#if os(iOS)
                    settingsURLButton(title: "便捷方法", subtitle: "iOS: `SystemSettings.openAppSettings()`", symbolName: "gearshape", tint: .blue) { SystemSettings.openAppSettings() }
                    settingsURLButton(title: "当前 App 设置页", subtitle: "iOS: `SystemSettings.open(.appSettings)`", symbolName: "iphone.gen3", tint: .blue) { SystemSettings.open(.appSettings) }
                    settingsURLButton(title: "直接打开 appSettings URL", subtitle: "iOS: `SystemSettings.open(url: SystemSettingsDestination.appSettings.url)`", symbolName: "gear", tint: .gray) { SystemSettings.open(url: SystemSettingsDestination.appSettings.url) }
                    iosInfoCard(
                        title: "appSettings URL",
                        subtitle: SystemSettingsDestination.appSettings.url.absoluteString,
                        symbolName: "link",
                        tint: .indigo
                    )
                    iosInfoCard(
                        title: "平台边界",
                        subtitle: "`SystemSettingsKit` 在 iOS 上只封装公开允许的设置入口；macOS 的 pane / anchor API 不会暴露到 iOS。",
                        symbolName: "exclamationmark.circle",
                        tint: .orange
                    )
#else
                    unsupportedPlatformButton(
                        title: "便捷方法",
                        subtitle: "iOS: `SystemSettings.openAppSettings()`",
                        symbolName: "gearshape",
                        tint: .blue
                    )
                    unsupportedPlatformButton(
                        title: "当前 App 设置页",
                        subtitle: "iOS: `SystemSettings.open(.appSettings)`，打开当前应用的系统设置页",
                        symbolName: "iphone.gen3",
                        tint: .blue
                    )
                    unsupportedPlatformButton(
                        title: "直接打开 appSettings URL",
                        subtitle: "iOS: `SystemSettings.open(url: SystemSettingsDestination.appSettings.url)`",
                        symbolName: "gear",
                        tint: .gray
                    )
                    iosInfoCard(
                        title: "appSettings URL",
                        subtitle: "app-settings:",
                        symbolName: "link",
                        tint: .indigo
                    )
                    iosInfoCard(
                        title: "平台边界",
                        subtitle: "`SystemSettingsKit` 在 iOS 上只封装公开允许的设置入口；macOS 的 pane / anchor API 不会暴露到 iOS。",
                        symbolName: "exclamationmark.circle",
                        tint: .orange
                    )
#endif
                }
            )
            settingsURLGroup(
                title: "通知设置页",
                buttons: {
#if os(iOS)
                    settingsURLButton(title: "便捷方法", subtitle: "iOS: `SystemSettings.openNotificationSettings()`", symbolName: "bell.badge", tint: .orange) { SystemSettings.openNotificationSettings() }
                    settingsURLButton(title: "通知设置页", subtitle: "iOS: `SystemSettings.open(.notificationSettings)`", symbolName: "bell.circle", tint: .orange) { SystemSettings.open(.notificationSettings) }
                    settingsURLButton(title: "直接打开 notificationSettings URL", subtitle: "iOS: `SystemSettings.open(url: SystemSettingsDestination.notificationSettings.url)`", symbolName: "link.badge.plus", tint: .brown) { SystemSettings.open(url: SystemSettingsDestination.notificationSettings.url) }
                    iosInfoCard(
                        title: "notificationSettings URL",
                        subtitle: SystemSettingsDestination.notificationSettings.url.absoluteString,
                        symbolName: "link",
                        tint: .brown
                    )
#else
                    unsupportedPlatformButton(
                        title: "便捷方法",
                        subtitle: "iOS: `SystemSettings.openNotificationSettings()`",
                        symbolName: "bell.badge",
                        tint: .orange
                    )
                    unsupportedPlatformButton(
                        title: "通知设置页",
                        subtitle: "iOS: `SystemSettings.open(.notificationSettings)`，打开当前应用通知设置页",
                        symbolName: "bell.circle",
                        tint: .orange
                    )
                    unsupportedPlatformButton(
                        title: "直接打开 notificationSettings URL",
                        subtitle: "iOS: `SystemSettings.open(url: SystemSettingsDestination.notificationSettings.url)`",
                        symbolName: "link.badge.plus",
                        tint: .brown
                    )
                    iosInfoCard(
                        title: "notificationSettings URL",
                        subtitle: "app-settings:notifications",
                        symbolName: "link",
                        tint: .brown
                    )
#endif
                }
            )
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.primary.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
    }

    #if os(macOS)
    private var permissionCardsSection: some View {
        LazyVGrid(
            columns: [
                GridItem(.adaptive(minimum: 280, maximum: 360), spacing: 16, alignment: .leading)
            ],
            alignment: .leading,
            spacing: 16,
        ) {
            PermissionCard(
                title: "辅助功能",
                subtitle: "辅助功能授权，用于窗口跟随和界面联动。",
                symbolName: "figure.wave",
                tint: .blue,
                buttonTitle: "打开辅助功能",
                helperText: "支持拖拽添加：\(Bundle.main.bundleURL.lastPathComponent)"
            ) { controller, sourceFrame in
                controller.authorize(
                    pane: .accessibility,
                    suggestedAppURLs: [Bundle.main.bundleURL],
                    sourceFrameInScreen: sourceFrame
                )
            }
            PermissionCard(
                title: "完全磁盘访问",
                subtitle: "完全磁盘访问授权示例。",
                symbolName: "externaldrive",
                tint: .indigo,
                buttonTitle: "打开完全磁盘访问",
                helperText: "支持拖拽添加：\(Bundle.main.bundleURL.lastPathComponent)"
            ) { controller, sourceFrame in
                controller.authorize(
                    pane: .fullDiskAccess,
                    suggestedAppURLs: [Bundle.main.bundleURL],
                    sourceFrameInScreen: sourceFrame
                )
            }
            PermissionCard(
                title: "输入监控",
                subtitle: "输入监控授权示例。",
                symbolName: "keyboard",
                tint: .mint,
                buttonTitle: "打开输入监控",
                helperText: "支持拖拽添加：\(Bundle.main.bundleURL.lastPathComponent)"
            ) { controller, sourceFrame in
                controller.authorize(
                    pane: .inputMonitoring,
                    suggestedAppURLs: [Bundle.main.bundleURL],
                    sourceFrameInScreen: sourceFrame
                )
            }
            PermissionCard(
                title: "屏幕录制",
                subtitle: "屏幕录制授权示例。",
                symbolName: "display",
                tint: .green,
                buttonTitle: "打开屏幕录制",
                helperText: "支持拖拽添加：\(Bundle.main.bundleURL.lastPathComponent)"
            ) { controller, sourceFrame in
                controller.authorize(
                    pane: .screenRecording,
                    suggestedAppURLs: [Bundle.main.bundleURL],
                    sourceFrameInScreen: sourceFrame
                )
            }
        }
    }
    #endif

    @ViewBuilder
    private func settingsURLGroup<Content: View>(title: String, @ViewBuilder buttons: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))

            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: 220, maximum: 320), spacing: 12)
                ],
                spacing: 12
            ) {
                buttons()
            }
        }
    }

    @ViewBuilder
    private func platformSectionHeader(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
            Text(subtitle)
                .font(.system(size: 12.5))
                .foregroundStyle(.secondary)
        }
        .padding(.top, 4)
    }

    @ViewBuilder
    private func settingsURLButton(title: String, subtitle: String? = nil, symbolName: String, tint: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: symbolName)
                    .font(.system(size: 14, weight: .semibold))
                    .frame(width: 18, height: 18)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 13, weight: .semibold))
                    if let subtitle {
                        Text(subtitle)
                            .font(.system(size: 11))
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                Spacer()
                Image(systemName: "arrow.up.right.square")
                    .font(.system(size: 13, weight: .medium))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(tint.opacity(0.12), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
        .foregroundStyle(tint)
    }

    @ViewBuilder
    private func unsupportedPlatformButton(title: String, subtitle: String, symbolName: String, tint: Color) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: symbolName)
                .font(.system(size: 14, weight: .semibold))
                .frame(width: 18, height: 18)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                Text("需要在 iOS 宿主应用中运行")
                    .font(.system(size: 10.5, weight: .medium))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "iphone")
                .font(.system(size: 13, weight: .medium))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(tint.opacity(0.10), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(tint.opacity(0.16), lineWidth: 1)
        )
        .foregroundStyle(tint)
    }

    @ViewBuilder
    private func iosInfoCard(title: String, subtitle: String, symbolName: String, tint: Color) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: symbolName)
                .font(.system(size: 14, weight: .semibold))
                .frame(width: 18, height: 18)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(tint.opacity(0.10), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(tint.opacity(0.16), lineWidth: 1)
        )
        .foregroundStyle(tint)
    }
}

#if os(macOS)
private struct PermissionCard: View {
    let title: String
    let subtitle: String
    let symbolName: String
    let tint: Color
    let buttonTitle: String
    let helperText: String
    let action: (PermissionFlowController, CGRect) -> Void

    @StateObject private var controller = PermissionFlow.makeController()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Image(systemName: symbolName)
                    .font(.system(size: 16, weight: .semibold))
                    .frame(width: 32, height: 32)
                    .background(tint.opacity(0.12), in: RoundedRectangle(cornerRadius: 10))
                    .foregroundStyle(tint)
                Spacer()
            }
            Text(title).font(.system(size: 18, weight: .semibold))
            VStack(alignment: .leading, spacing: 3) {
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                Button(buttonTitle) {
                    action(controller, clickSourceFrameInScreen())
                }
                .buttonStyle(.borderedProminent)
                .tint(tint)
                .controlSize(.small)
                Text(helperText)
                    .font(.system(size: 10.5))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.primary.opacity(0.06), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.black.opacity(0.045), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 14, y: 5)
    }

    private func clickSourceFrameInScreen() -> CGRect {
        let mouseLocation = NSEvent.mouseLocation
        return CGRect(x: mouseLocation.x - 16, y: mouseLocation.y - 16, width: 32, height: 32)
    }
}
#endif

#Preview {
    ContentView()
}
