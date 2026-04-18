import Foundation
import Testing
@testable import SandboxDrop

@Test
func paneURLsUseSecuritySettingsDeepLink() {
    #expect(
        SandboxPermissionPane.fullDiskAccess.settingsURL.absoluteString ==
        "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
    )
}

@Test
@MainActor
func controllerAcceptsOnlyUniqueAppBundles() {
    let controller = SandboxDropController()
    let appURL = URL(fileURLWithPath: "/Applications/Test.app")

    controller.registerDroppedApp(appURL)
    controller.registerDroppedApp(appURL)
    controller.registerDroppedApp(URL(fileURLWithPath: "/tmp/not-an-app.txt"))

    #expect(controller.droppedApps == [appURL])
}
