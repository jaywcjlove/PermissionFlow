import Foundation
import Testing
@testable import PermissionFlow
@testable import SystemSettingsKit

@Test
func paneURLsUseSecuritySettingsDeepLink() {
    #expect(
        PermissionFlowPane.fullDiskAccess.settingsURL.absoluteString ==
        "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension?Privacy_AllFiles"
    )
    #expect(
        PermissionFlowPane.accessibility.settingsURL.absoluteString ==
        "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension?Privacy_Accessibility"
    )
}

@Test
func accessibilityPaneTitleFollowsSystemSettingsRename() {
    let macOS26 = OperatingSystemVersion(majorVersion: 26, minorVersion: 0, patchVersion: 0)
    let macOS27 = OperatingSystemVersion(majorVersion: 27, minorVersion: 0, patchVersion: 0)

    #expect(
        PermissionFlowResources.accessibilityName(operatingSystemVersion: macOS26)
            == PermissionFlowResources.accessibilityNameKey
    )
    #expect(
        PermissionFlowResources.accessibilityName(operatingSystemVersion: macOS27)
            == PermissionFlowResources.deviceControlAndDataAccessNameKey
    )
    #expect(PermissionFlowResources.accessibilityNameKey == "permission_flow.pane.accessibility")
    #expect(
        PermissionFlowResources.deviceControlAndDataAccessNameKey
            == "permission_flow.pane.device_control_and_data_access"
    )

    #expect(PermissionFlowPane.usesDeviceControlAndDataAccessTitle(operatingSystemVersion: macOS26) == false)
    #expect(PermissionFlowPane.usesDeviceControlAndDataAccessTitle(operatingSystemVersion: macOS27))

    #expect(
        PermissionFlowPane.accessibility.localizedTitle(
            localeIdentifier: "en",
            operatingSystemVersion: macOS26
        ) == "Accessibility"
    )
    #expect(
        PermissionFlowPane.accessibility.localizedTitle(
            localeIdentifier: "en",
            operatingSystemVersion: macOS27
        ) == "Device Control and Data Access"
    )
    #expect(
        PermissionFlowPane.accessibility.localizedTitle(
            localeIdentifier: "zh-Hans",
            operatingSystemVersion: macOS27
        ) == "设备控制和数据访问"
    )
    #expect(
        PermissionFlowPane.accessibility.localizedTitle(
            localeIdentifier: "zh-Hant",
            operatingSystemVersion: macOS27
        ) == "裝置控制和資料取用"
    )
    #expect(
        PermissionFlowResources.accessibilityNameResource(operatingSystemVersion: macOS26).key
            == PermissionFlowResources.accessibilityNameKey
    )
    #expect(
        PermissionFlowResources.accessibilityNameResource(operatingSystemVersion: macOS27).key
            == PermissionFlowResources.deviceControlAndDataAccessNameKey
    )
}

@Test
func localizedStringResolvesNameKeyFromPackageBundle() {
    #expect(
        PermissionFlowResources.localizedString(
            for: PermissionFlowResources.accessibilityNameKey,
            localeIdentifier: "en"
        ) == "Accessibility"
    )
    #expect(
        PermissionFlowResources.localizedString(
            for: PermissionFlowResources.accessibilityNameKey,
            localeIdentifier: "zh-Hans"
        ) == "辅助功能"
    )
    #expect(
        PermissionFlowResources.localizedString(
            for: PermissionFlowResources.deviceControlAndDataAccessNameKey,
            localeIdentifier: "zh-Hans"
        ) == "设备控制和数据访问"
    )
    #expect(
        PermissionFlowResources.localizedString(
            for: PermissionFlowResources.deviceControlAndDataAccessNameKey,
            localeIdentifier: "zh-Hant"
        ) == "裝置控制和資料取用"
    )
    let currentNameKey = PermissionFlowResources.accessibilityName()
    let currentName = PermissionFlowResources.localizedString(for: currentNameKey, localeIdentifier: "en")
    #expect(currentName == "Accessibility" || currentName == "Device Control and Data Access")
    #expect(
        PermissionFlowResources.localizedStringResource(for: PermissionFlowResources.accessibilityNameKey).key
            == PermissionFlowResources.accessibilityNameKey
    )
    #expect(
        PermissionFlowResources.localizedStringResource(
            for: PermissionFlowResources.deviceControlAndDataAccessNameKey
        ).key == PermissionFlowResources.deviceControlAndDataAccessNameKey
    )
}

@Test
func typedDisplaysAnchorBuildsDeepLink() {
    #expect(
        SystemSettingsDestination.displays(anchor: .resolutionSection).url.absoluteString ==
        "x-apple.systempreferences:com.apple.Displays-Settings.extension?resolutionSection"
    )
}

@Test
func typedLoginItemsAnchorBuildsDeepLink() {
    #expect(
        SystemSettingsDestination.loginItems(anchor: .extensionItems).url.absoluteString ==
        "x-apple.systempreferences:com.apple.LoginItems-Settings.extension?ExtensionItems"
    )
    #expect(
        SystemSettingsDestination.loginItems(extensionPointIdentifier: .quickLookPreview).url.absoluteString ==
        "x-apple.systempreferences:com.apple.ExtensionsPreferences?extensionPointIdentifier=com.apple.quicklook.preview"
    )
    #expect(
        SystemSettingsDestination.loginItems(extensionPointIdentifier: "com.apple.quicklook.preview").url.absoluteString ==
        "x-apple.systempreferences:com.apple.ExtensionsPreferences?extensionPointIdentifier=com.apple.quicklook.preview"
    )

    for extensionPointIdentifier in LoginItemsExtensionPointIdentifier.allCases {
        #expect(
            SystemSettingsDestination.loginItems(extensionPointIdentifier: extensionPointIdentifier).url.absoluteString ==
            "x-apple.systempreferences:com.apple.ExtensionsPreferences?extensionPointIdentifier=\(extensionPointIdentifier.rawValue)"
        )
    }
}

@Test
func typedWiFiAnchorBuildsDeepLink() {
    #expect(
        SystemSettingsDestination.wifi.url.absoluteString ==
        "x-apple.systempreferences:com.apple.wifi-settings-extension"
    )
    #expect(
        SystemSettingsDestination.wifi(anchor: .advanced).url.absoluteString ==
        "x-apple.systempreferences:com.apple.wifi-settings-extension?Advanced"
    )
    #expect(
        SystemSettingsDestination.wifi(anchor: .generalDetails).url.absoluteString ==
        "x-apple.systempreferences:com.apple.wifi-settings-extension?General_Details"
    )
    #expect(
        SystemSettingsDestination.wifi(anchor: .generalJoin).url.absoluteString ==
        "x-apple.systempreferences:com.apple.wifi-settings-extension?General_Join"
    )
    #expect(
        SystemSettingsDestination.wifi(anchor: .generalMain).url.absoluteString ==
        "x-apple.systempreferences:com.apple.wifi-settings-extension?General_Main"
    )
}

@Test
func typedVPNAnchorBuildsDeepLink() {
    #expect(
        SystemSettingsDestination.vpn.url.absoluteString ==
        "x-apple.systempreferences:com.apple.NetworkExtensionSettingsUI.NESettingsUIExtension*vpn"
    )
    #expect(
        SystemSettingsDestination.vpn(anchor: .vpn).url.absoluteString ==
        "x-apple.systempreferences:com.apple.NetworkExtensionSettingsUI.NESettingsUIExtension*vpn?VPN"
    )
    #expect(
        SystemSettingsDestination.vpn(anchor: .vpnOnDemand).url.absoluteString ==
        "x-apple.systempreferences:com.apple.NetworkExtensionSettingsUI.NESettingsUIExtension*vpn?VPN%20on%20Demand"
    )
}

@Test
func accessibilityAnchorBuildsDeepLink() {
    #expect(
        SystemSettingsDestination.accessibility.url.absoluteString ==
        "x-apple.systempreferences:com.apple.Accessibility-Settings.extension"
    )
    #expect(
        SystemSettingsDestination.accessibility(anchor: .voiceOver).url.absoluteString ==
        "x-apple.systempreferences:com.apple.Accessibility-Settings.extension?AX_feature.voiceOver"
    )
    #expect(
        SystemSettingsDestination.accessibility(anchor: .spokenContent).url.absoluteString ==
        "x-apple.systempreferences:com.apple.Accessibility-Settings.extension?AX_FEATURE_SPOKENCONTENT"
    )
    #expect(
        SystemSettingsDestination.accessibility(anchor: "AX_ZOOM_MAX_FACTOR").url.absoluteString ==
        "x-apple.systempreferences:com.apple.Accessibility-Settings.extension?AX_ZOOM_MAX_FACTOR"
    )
}

@Test
@MainActor
func controllerAcceptsOnlyUniqueAppBundles() {
    let controller = PermissionFlowController()
    let appURL = URL(fileURLWithPath: "/Applications/Test.app")

    controller.registerDroppedApp(appURL)
    controller.registerDroppedApp(appURL)
    controller.registerDroppedApp(URL(fileURLWithPath: "/tmp/not-an-app.txt"))

    #expect(controller.droppedApps == [appURL])
}
