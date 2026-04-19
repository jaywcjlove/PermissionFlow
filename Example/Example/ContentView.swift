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
            .frame(minWidth: 820, minHeight: 420)
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
            Text("PermissionFlow / SystemSettingsKit Example")
                .font(.system(size: 32, weight: .bold, design: .rounded))
            VStack(alignment: .leading, spacing: 6) {
#if os(macOS)
                Text("Each button opens the corresponding system settings privacy page. Only permission pages that support drag-and-drop app addition will show the floating authorization window. It's recommended to drag in the current Example.app by default.")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                Text("Permission pages like Automation, Camera, Microphone, and Files & Folders that don't natively support drag-and-drop app addition will only open the settings interface without showing the floating window.")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.primary)
#else
                Text("Current page is split by platform. iOS side only shows available SystemSettingsKit entry points; PermissionFlow only supports macOS.")
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
                Text("System Settings URL Testing")
                    .font(.system(size: 24, weight: .bold))
#if os(macOS)
                Text("Below shows the capabilities of `SystemSettingsKit` split by platform. The macOS area is for testing `SystemSettings-URLs-macOS` style deeplinks; the iOS area shows currently wrapped iOS settings entry points.")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
#else
                Text("Current page only shows iOS available `SystemSettingsKit` examples. macOS-specific pane/anchor deeplinks and `PermissionFlow` authorization guidance won't be displayed on iOS.")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
#endif
            }

#if os(macOS)
            platformSectionHeader(
                title: "macOS Examples",
                subtitle: "Pane identifier, anchor and strongly-typed navigation for `System Settings`."
            )
            settingsURLGroup(
                title: "Privacy & Security",
                buttons: {
                    settingsURLButton(title: "Privacy & Security Home", subtitle: "Navigate to Privacy & Security homepage", symbolName: "lock.shield", tint: .gray) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.settings.PrivacySecurity.extension")) }
                    settingsURLButton(title: "Advanced", subtitle: "Navigate to Privacy & Security > Advanced", symbolName: "gearshape.2", tint: .gray) { SystemSettings.open(.privacy(anchor: .advanced)) }
                    settingsURLButton(title: "Security", subtitle: "Navigate to Privacy & Security > Security", symbolName: "shield", tint: .gray) { SystemSettings.open(.privacy(anchor: .security)) }
                    settingsURLButton(title: "Security Improvements", subtitle: "Navigate to Privacy & Security > Security Improvements", symbolName: "shield.lefthalf.filled.badge.checkmark", tint: .green) { SystemSettings.open(.privacy(anchor: .securityImprovements)) }
                    settingsURLButton(title: "FileVault", subtitle: "Navigate to Privacy & Security > FileVault", symbolName: "lock.rectangle", tint: .blue) { SystemSettings.open(.privacy(anchor: .fileVault)) }
                    settingsURLButton(title: "Lockdown Mode", subtitle: "Navigate to Privacy & Security > Lockdown Mode", symbolName: "lock.trianglebadge.exclamationmark", tint: .red) { SystemSettings.open(.privacy(anchor: .lockdownMode)) }
                    settingsURLButton(title: "Location Access Report", subtitle: "Navigate to Privacy & Security > Location Access Report", symbolName: "location.viewfinder", tint: .orange) { SystemSettings.open(.privacy(anchor: .locationAccessReport)) }
                    settingsURLButton(title: "Advertising", subtitle: "Navigate to Privacy & Security > Advertising", symbolName: "megaphone", tint: .orange) { SystemSettings.open(.privacy(anchor: .privacyAdvertising)) }
                    settingsURLButton(title: "Accessibility", subtitle: "Navigate to Privacy & Security > Accessibility", symbolName: "figure.wave", tint: .blue) { SystemSettings.open(.privacy(anchor: .privacyAccessibility)) }
                    settingsURLButton(title: "Automation", subtitle: "Navigate to Privacy & Security > Automation", symbolName: "apple.terminal.on.rectangle", tint: .brown) { SystemSettings.open(.privacy(anchor: .privacyAutomation)) }
                    settingsURLButton(title: "App Management", subtitle: "Navigate to Privacy & Security > App Management", symbolName: "shippingbox", tint: .brown) { SystemSettings.open(.privacy(anchor: .privacyAppBundles)) }
                    settingsURLButton(title: "Analytics & Improvements", subtitle: "Navigate to Privacy & Security > Analytics & Improvements", symbolName: "chart.bar", tint: .cyan) { SystemSettings.open(.privacy(anchor: .privacyAnalytics)) }
                    settingsURLButton(title: "Audio Capture", subtitle: "Navigate to Privacy & Security > Audio Capture", symbolName: "waveform", tint: .purple) { SystemSettings.open(.privacy(anchor: .privacyAudioCapture)) }
                    settingsURLButton(title: "Bluetooth", subtitle: "Navigate to Privacy & Security > Bluetooth", symbolName: "bolt.horizontal.circle", tint: .blue) { SystemSettings.open(.privacy(anchor: .privacyBluetooth)) }
                    settingsURLButton(title: "Calendar", subtitle: "Navigate to Privacy & Security > Calendar", symbolName: "calendar", tint: .red) { SystemSettings.open(.privacy(anchor: .privacyCalendars)) }
                    settingsURLButton(title: "Camera", subtitle: "Navigate to Privacy & Security > Camera", symbolName: "camera", tint: .pink) { SystemSettings.open(.privacy(anchor: .privacyCamera)) }
                    settingsURLButton(title: "Contacts", subtitle: "Navigate to Privacy & Security > Contacts", symbolName: "person.crop.circle.badge.checkmark", tint: .blue) { SystemSettings.open(.privacy(anchor: .privacyContacts)) }
                    settingsURLButton(title: "Developer Tools", subtitle: "Navigate to Privacy & Security > Developer Tools", symbolName: "hammer", tint: .orange) { SystemSettings.open(.privacy(anchor: .privacyDevTools)) }
                    settingsURLButton(title: "Files and Folders", subtitle: "Navigate to Privacy & Security > Files and Folders", symbolName: "folder", tint: .teal) { SystemSettings.open(.privacy(anchor: .privacyFilesAndFolders)) }
                    settingsURLButton(title: "Focus", subtitle: "Navigate to Privacy & Security > Focus", symbolName: "moon.circle", tint: .indigo) { SystemSettings.open(.privacy(anchor: .privacyFocus)) }
                    settingsURLButton(title: "HomeKit", subtitle: "Navigate to Privacy & Security > HomeKit", symbolName: "house", tint: .mint) { SystemSettings.open(.privacy(anchor: .privacyHomeKit)) }
                    settingsURLButton(title: "Input Monitoring", subtitle: "Navigate to Privacy & Security > Input Monitoring", symbolName: "keyboard", tint: .mint) { SystemSettings.open(.privacy(anchor: .privacyListenEvent)) }
                    settingsURLButton(title: "Location Services", subtitle: "Navigate to Privacy & Security > Location Services", symbolName: "location", tint: .orange) { SystemSettings.open(.privacy(anchor: .privacyLocationServices)) }
                    settingsURLButton(title: "Media & Apple Music", subtitle: "Navigate to Privacy & Security > Media & Apple Music", symbolName: "music.note.list", tint: .red) { SystemSettings.open(.privacy(anchor: .privacyMedia)) }
                    settingsURLButton(title: "Microphone", subtitle: "Navigate to Privacy & Security > Microphone", symbolName: "mic", tint: .red) { SystemSettings.open(.privacy(anchor: .privacyMicrophone)) }
                    settingsURLButton(title: "Motion & Fitness", subtitle: "Navigate to Privacy & Security > Motion & Fitness", symbolName: "figure.walk", tint: .green) { SystemSettings.open(.privacy(anchor: .privacyMotion)) }
                    settingsURLButton(title: "Sensitive Content Warning", subtitle: "Navigate to Privacy & Security > Sensitive Content Warning", symbolName: "exclamationmark.shield", tint: .pink) { SystemSettings.open(.privacy(anchor: .privacyNudityDetection)) }
                    settingsURLButton(title: "Keychain & Passkeys", subtitle: "Navigate to Privacy & Security > Passkey Access", symbolName: "key", tint: .yellow) { SystemSettings.open(.privacy(anchor: .privacyPasskeyAccess)) }
                    settingsURLButton(title: "Photos", subtitle: "Navigate to Privacy & Security > Photos", symbolName: "photo", tint: .purple) { SystemSettings.open(.privacy(anchor: .privacyPhotos)) }
                    settingsURLButton(title: "Reminders", subtitle: "Navigate to Privacy & Security > Reminders", symbolName: "list.bullet", tint: .blue) { SystemSettings.open(.privacy(anchor: .privacyReminders)) }
                    settingsURLButton(title: "Remote Desktop", subtitle: "Navigate to Privacy & Security > Remote Desktop", symbolName: "desktopcomputer.and.arrow.down", tint: .cyan) { SystemSettings.open(.privacy(anchor: .privacyRemoteDesktop)) }
                    settingsURLButton(title: "Screen Recording", subtitle: "Navigate to Privacy & Security > Screen Recording", symbolName: "display", tint: .green) { SystemSettings.open(.privacy(anchor: .privacyScreenCapture)) }
                    settingsURLButton(title: "Speech Recognition", subtitle: "Navigate to Privacy & Security > Speech Recognition", symbolName: "waveform.badge.mic", tint: .orange) { SystemSettings.open(.privacy(anchor: .privacySpeechRecognition)) }
                    settingsURLButton(title: "System Services", subtitle: "Navigate to Privacy & Security > System Services", symbolName: "gearshape.2.fill", tint: .gray) { SystemSettings.open(.privacy(anchor: .privacySystemServices)) }
                    settingsURLButton(title: "Full Disk Access", subtitle: "Navigate to Privacy & Security > Full Disk Access", symbolName: "externaldrive", tint: .indigo) { SystemSettings.open(.privacy(anchor: .privacyAllFiles)) }
                }
            )

            settingsURLGroup(
                title: "Common Pages",
                buttons: {
                    settingsURLButton(title: "Apple ID", symbolName: "person.crop.circle", tint: .blue) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.systempreferences.AppleIDSettings")) }
                    settingsURLButton(title: "Appearance", symbolName: "circle.lefthalf.filled", tint: .gray) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Appearance-Settings.extension")) }
                    settingsURLButton(title: "Accessibility", symbolName: "accessibility", tint: .blue) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Accessibility-Settings.extension")) }
                    settingsURLButton(title: "Bluetooth", symbolName: "bolt.horizontal.circle", tint: .blue) { SystemSettings.open(.bluetooth) }
                    settingsURLButton(title: "Battery", symbolName: "battery.100", tint: .green) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Battery-Settings.extension")) }
                    settingsURLButton(title: "Date & Time", symbolName: "calendar", tint: .orange) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Date-Time-Settings.extension")) }
                    settingsURLButton(title: "Desktop & Dock", symbolName: "menubar.dock.rectangle", tint: .teal) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Desktop-Settings.extension")) }
                    settingsURLButton(title: "Displays", symbolName: "display.2", tint: .indigo) { SystemSettings.open(.displays) }
                    settingsURLButton(title: "General", symbolName: "gearshape", tint: .secondary) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.systempreferences.GeneralSettings")) }
                    settingsURLButton(title: "Login Items", symbolName: "person.badge.key", tint: .brown) { SystemSettings.open(.loginItems) }
                    settingsURLButton(title: "Network", symbolName: "network", tint: .cyan) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Network-Settings.extension")) }
                    settingsURLButton(title: "Passwords", symbolName: "key", tint: .yellow) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Passwords")) }
                    settingsURLButton(title: "Wallpaper", symbolName: "photo.on.rectangle", tint: .purple) { SystemSettings.open(.wallpaper) }
                    settingsURLButton(title: "Screen Saver", symbolName: "sparkles.tv", tint: .pink) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Wallpaper-Settings.extension", anchor: "ScreenSaver")) }
                }
            )

            settingsURLGroup(
                title: "Display Sub-pages",
                buttons: {
                    settingsURLButton(title: "Display List", subtitle: "Navigate to Displays > Display List", symbolName: "rectangle.on.rectangle", tint: .indigo) { SystemSettings.open(.displays(anchor: .displaysSection)) }
                    settingsURLButton(title: "Arrangement", subtitle: "Navigate to Displays > Arrangement", symbolName: "square.grid.3x3", tint: .blue) { SystemSettings.open(.displays(anchor: .arrangementSection)) }
                    settingsURLButton(title: "Resolution", subtitle: "Navigate to Displays > Resolution", symbolName: "aspectratio", tint: .green) { SystemSettings.open(.displays(anchor: .resolutionSection)) }
                    settingsURLButton(title: "Night Shift", subtitle: "Navigate to Displays > Night Shift", symbolName: "moon.stars", tint: .orange) { SystemSettings.open(.displays(anchor: .nightShiftSection)) }
                    settingsURLButton(title: "Color Profile", subtitle: "Navigate to Displays > Color Profile", symbolName: "paintpalette", tint: .pink) { SystemSettings.open(.displays(anchor: .profileSection)) }
                    settingsURLButton(title: "Sidecar", subtitle: "Navigate to Displays > Sidecar", symbolName: "ipad.and.arrow.forward", tint: .mint) { SystemSettings.open(.displays(anchor: .sidecarSection)) }
                    settingsURLButton(title: "Advanced", subtitle: "Navigate to Displays > Advanced", symbolName: "slider.horizontal.3", tint: .gray) { SystemSettings.open(.displays(anchor: .advancedSection)) }
                    settingsURLButton(title: "Ambient Display", subtitle: "Navigate to Displays > Ambient Display", symbolName: "sparkles", tint: .purple) { SystemSettings.open(.displays(anchor: .ambienceSection)) }
                    settingsURLButton(title: "Display Characteristics", subtitle: "Navigate to Displays > Display Characteristics", symbolName: "dial.medium", tint: .teal) { SystemSettings.open(.displays(anchor: .characteristicSection)) }
                    settingsURLButton(title: "Miscellaneous", subtitle: "Navigate to Displays > Miscellaneous", symbolName: "ellipsis.circle", tint: .secondary) { SystemSettings.open(.displays(anchor: .miscellaneousSection)) }
                }
            )

            settingsURLGroup(
                title: "System & Advanced Pages",
                buttons: {
                    settingsURLButton(title: "AirDrop & Handoff", symbolName: "handoff", tint: .mint) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.AirDrop-Handoff-Settings.extension")) }
                    settingsURLButton(title: "CDs & DVDs", symbolName: "opticaldiscdrive", tint: .orange) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.CD-DVD-Settings.extension")) }
                    settingsURLButton(title: "Coverage", symbolName: "checkmark.shield", tint: .green) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Coverage-Settings.extension")) }
                    settingsURLButton(title: "Family Sharing", symbolName: "person.3", tint: .pink) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Family-Settings.extension")) }
                    settingsURLButton(title: "Follow Up", symbolName: "list.bullet.clipboard", tint: .orange) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.FollowUpSettings.FollowUpSettingsExtension")) }
                    settingsURLButton(title: "Headphones", symbolName: "headphones", tint: .indigo) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.HeadphoneSettings")) }
                    settingsURLButton(title: "Language & Region", symbolName: "globe", tint: .blue) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Localization-Settings.extension")) }
                    settingsURLButton(title: "Profiles", symbolName: "doc.badge.gearshape", tint: .brown) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Profiles-Settings.extension")) }
                    settingsURLButton(title: "Sharing", symbolName: "square.and.arrow.up.on.square", tint: .teal) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Sharing-Settings.extension")) }
                    settingsURLButton(title: "Software Update", symbolName: "arrow.down.circle", tint: .green) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Software-Update-Settings.extension")) }
                    settingsURLButton(title: "Startup Disk", symbolName: "internaldrive", tint: .gray) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Startup-Disk-Settings.extension")) }
                    settingsURLButton(title: "Storage", symbolName: "externaldrive.fill.badge.person.crop", tint: .indigo) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.settings.Storage")) }
                    settingsURLButton(title: "Time Machine", symbolName: "clock.arrow.trianglehead.counterclockwise.rotate.90", tint: .mint) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Time-Machine-Settings.extension")) }
                    settingsURLButton(title: "Touch ID", symbolName: "touchid", tint: .primary) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Touch-ID-Settings.extension")) }
                    settingsURLButton(title: "Transfer or Reset", symbolName: "arrow.triangle.2.circlepath", tint: .red) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Transfer-Reset-Settings.extension")) }
                    settingsURLButton(title: "Users & Groups", symbolName: "person.2", tint: .cyan) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.Users-Groups-Settings.extension")) }
                    settingsURLButton(title: "About This Mac", symbolName: "info.circle", tint: .blue) { SystemSettings.open(SystemSettingsDestination(paneIdentifier: "com.apple.SystemProfiler.AboutExtension")) }
                }
            )
#endif

            platformSectionHeader(
                title: "iOS Examples",
                subtitle: "Currently `SystemSettingsKit` on iOS only wraps UIKit publicly supported settings entry points. Here we show the current App settings page and notification settings page."
            )
            settingsURLGroup(
                title: "Current App Settings Page",
                buttons: {
#if os(iOS)
                    settingsURLButton(title: "Convenience Method", subtitle: "iOS: `SystemSettings.openAppSettings()`", symbolName: "gearshape", tint: .blue) { SystemSettings.openAppSettings() }
                    settingsURLButton(title: "Current App Settings Page", subtitle: "iOS: `SystemSettings.open(.appSettings)`", symbolName: "iphone.gen3", tint: .blue) { SystemSettings.open(.appSettings) }
                    settingsURLButton(title: "Direct Open appSettings URL", subtitle: "iOS: `SystemSettings.open(url: SystemSettingsDestination.appSettings.url)`", symbolName: "gear", tint: .gray) { SystemSettings.open(url: SystemSettingsDestination.appSettings.url) }
                    iosInfoCard(
                        title: "appSettings URL",
                        subtitle: SystemSettingsDestination.appSettings.url.absoluteString,
                        symbolName: "link",
                        tint: .indigo
                    )
                    iosInfoCard(
                        title: "Platform Boundaries",
                        subtitle: "`SystemSettingsKit` on iOS only wraps publicly allowed settings entry points; macOS pane/anchor APIs are not exposed to iOS.",
                        symbolName: "exclamationmark.circle",
                        tint: .orange
                    )
#else
                    unsupportedPlatformButton(
                        title: "Convenience Method",
                        subtitle: "iOS: `SystemSettings.openAppSettings()`",
                        symbolName: "gearshape",
                        tint: .blue
                    )
                    unsupportedPlatformButton(
                        title: "Current App Settings Page",
                        subtitle: "iOS: `SystemSettings.open(.appSettings)`, opens the current app's system settings page",
                        symbolName: "iphone.gen3",
                        tint: .blue
                    )
                    unsupportedPlatformButton(
                        title: "Direct Open appSettings URL",
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
                        title: "Platform Boundaries",
                        subtitle: "`SystemSettingsKit` on iOS only wraps publicly allowed settings entry points; macOS pane/anchor APIs are not exposed to iOS.",
                        symbolName: "exclamationmark.circle",
                        tint: .orange
                    )
#endif
                }
            )
            settingsURLGroup(
                title: "Notification Settings Page",
                buttons: {
#if os(iOS)
                    settingsURLButton(title: "Convenience Method", subtitle: "iOS: `SystemSettings.openNotificationSettings()`", symbolName: "bell.badge", tint: .orange) { SystemSettings.openNotificationSettings() }
                    settingsURLButton(title: "Notification Settings Page", subtitle: "iOS: `SystemSettings.open(.notificationSettings)`", symbolName: "bell.circle", tint: .orange) { SystemSettings.open(.notificationSettings) }
                    settingsURLButton(title: "Direct Open notificationSettings URL", subtitle: "iOS: `SystemSettings.open(url: SystemSettingsDestination.notificationSettings.url)`", symbolName: "link.badge.plus", tint: .brown) { SystemSettings.open(url: SystemSettingsDestination.notificationSettings.url) }
                    iosInfoCard(
                        title: "notificationSettings URL",
                        subtitle: SystemSettingsDestination.notificationSettings.url.absoluteString,
                        symbolName: "link",
                        tint: .brown
                    )
#else
                    unsupportedPlatformButton(
                        title: "Convenience Method",
                        subtitle: "iOS: `SystemSettings.openNotificationSettings()`",
                        symbolName: "bell.badge",
                        tint: .orange
                    )
                    unsupportedPlatformButton(
                        title: "Notification Settings Page",
                        subtitle: "iOS: `SystemSettings.open(.notificationSettings)`, opens the current app's notification settings page",
                        symbolName: "bell.circle",
                        tint: .orange
                    )
                    unsupportedPlatformButton(
                        title: "Direct Open notificationSettings URL",
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
                title: "Accessibility",
                subtitle: "Accessibility authorization for window tracking and interface interaction.",
                symbolName: "figure.wave",
                tint: .blue,
                buttonTitle: "Open Accessibility",
                helperText: "Supports drag-and-drop: \(Bundle.main.bundleURL.lastPathComponent)"
            ) { controller, sourceFrame in
                controller.authorize(
                    pane: .accessibility,
                    suggestedAppURLs: [Bundle.main.bundleURL],
                    sourceFrameInScreen: sourceFrame
                )
            }
            PermissionCard(
                title: "Full Disk Access",
                subtitle: "Full disk access authorization example.",
                symbolName: "externaldrive",
                tint: .indigo,
                buttonTitle: "Open Full Disk Access",
                helperText: "Supports drag-and-drop: \(Bundle.main.bundleURL.lastPathComponent)"
            ) { controller, sourceFrame in
                controller.authorize(
                    pane: .fullDiskAccess,
                    suggestedAppURLs: [Bundle.main.bundleURL],
                    sourceFrameInScreen: sourceFrame
                )
            }
            PermissionCard(
                title: "Input Monitoring",
                subtitle: "Input monitoring authorization example.",
                symbolName: "keyboard",
                tint: .mint,
                buttonTitle: "Open Input Monitoring",
                helperText: "Supports drag-and-drop: \(Bundle.main.bundleURL.lastPathComponent)"
            ) { controller, sourceFrame in
                controller.authorize(
                    pane: .inputMonitoring,
                    suggestedAppURLs: [Bundle.main.bundleURL],
                    sourceFrameInScreen: sourceFrame
                )
            }
            PermissionCard(
                title: "Screen Recording",
                subtitle: "Screen recording authorization example.",
                symbolName: "display",
                tint: .green,
                buttonTitle: "Open Screen Recording",
                helperText: "Supports drag-and-drop: \(Bundle.main.bundleURL.lastPathComponent)"
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
                Text("Requires iOS host app to run")
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
