# PermissionFlow

`PermissionFlow` is a Swift Package for Apple platform apps that bundles two focused libraries:

- `PermissionFlow`: macOS-only floating guidance for drag-based privacy authorization
- `SystemSettingsKit`: typed Settings deeplinks for macOS, with partial iOS support

It opens the correct privacy page automatically and, for panes that support drag-based authorization, shows a floating helper panel that follows the `System Settings` window and lets the user drag the current `.app` bundle into the permission list.

## Features

- Opens the target `System Settings` privacy pane automatically
- Animates the floating panel from the click position to the `System Settings` window
- Follows the `System Settings` window while it moves
- Shows the current app as a native drag source
- Keeps only one active floating panel at a time
- Closes the floating panel automatically when `System Settings` closes
- Supports adaptive floating panel height based on content

## Requirements

- macOS 13+
- Swift 6 package toolchain
- SwiftUI + AppKit host application

## Installation

Add the package to your app:

```swift
dependencies: [
    .package(url: "https://github.com/your-org/PermissionFlow.git", from: "1.0.0")
]
```

This package now exposes two library products:

- `PermissionFlow`: floating authorization guidance for supported privacy panes on macOS
- `SystemSettingsKit`: reusable deeplink API for arbitrary System Settings pages

Then add the product you need to your target:

```swift
.target(
    name: "YourApp",
    dependencies: [
        .product(name: "PermissionFlow", package: "PermissionFlow"),
        .product(name: "SystemSettingsKit", package: "PermissionFlow")
    ]
)
```

Platform support:

- `PermissionFlow`: `macOS 13+`
- `SystemSettingsKit`: `macOS 13+`, `iOS 16+`

`SystemSettingsKit` is intentionally partial on iOS. The macOS deeplink-based pane and anchor APIs remain macOS-only, while iOS only exposes destinations that are publicly supported by UIKit, such as the current app's Settings page.

## Supported Permission Panes

`PermissionFlow` only covers the privacy panes that support the floating drag-to-authorize workflow:

- `Accessibility`
- `Full Disk Access`
- `Input Monitoring`
- `Screen Recording`

For every other `System Settings` page or privacy subsection, use `SystemSettingsKit`.

## Quick Start

### SwiftUI button

```swift
import PermissionFlow
import SwiftUI

struct ContentView: View {
    var body: some View {
        PermissionFlowButton(
            title: "Grant Accessibility",
            pane: .accessibility,
            suggestedAppURLs: [Bundle.main.bundleURL]
        )
    }
}
```

### Manual controller usage

Use `PermissionFlowController` when you want to control the flow yourself:

```swift
import PermissionFlow
import SwiftUI

@MainActor
final class PermissionViewModel: ObservableObject {
    private let controller = PermissionFlow.makeController()

    func requestFullDiskAccess() {
        controller.authorize(
            pane: .fullDiskAccess,
            suggestedAppURLs: [Bundle.main.bundleURL]
        )
    }
}
```

### Keep the launch animation

If you use `PermissionFlowButton`, the package captures the click position for you and the floating panel will animate from the button click to the `System Settings` window automatically.

If you call `PermissionFlowController.authorize(...)` manually, pass the click source frame yourself. Otherwise the panel will still appear, but it will skip the launch animation and jump directly to the target position.

```swift
import AppKit
import PermissionFlow

@MainActor
final class PermissionViewModel: ObservableObject {
    private let controller = PermissionFlow.makeController()

    func requestAccessibility() {
        let mouseLocation = NSEvent.mouseLocation
        let sourceFrame = CGRect(
            x: mouseLocation.x - 16,
            y: mouseLocation.y - 16,
            width: 32,
            height: 32
        )

        controller.authorize(
            pane: .accessibility,
            suggestedAppURLs: [Bundle.main.bundleURL],
            sourceFrameInScreen: sourceFrame
        )
    }
}
```

## Public API

### `PermissionFlowButton`

Convenience SwiftUI button for launching a permission flow.

```swift
PermissionFlowButton(
    title: "Open Screen Recording",
    pane: .screenRecording,
    suggestedAppURLs: [Bundle.main.bundleURL],
    configuration: .init()
)
```

### `PermissionFlow.makeController`

Creates a reusable controller:

```swift
let controller = PermissionFlow.makeController(
    configuration: .init(
        requiredAppURLs: [Bundle.main.bundleURL],
        promptForAccessibilityTrust: false
    )
)
```

### `PermissionFlowController`

Main entry points:

- `authorize(pane:suggestedAppURLs:sourceFrameInScreen:)`
- `showPanel()`
- `closePanel()`
- `resetDroppedApps()`
- `registerDroppedApp(_:)`

### `SystemSettings.open`

Open any System Settings page directly from a pane identifier and optional anchor:

```swift
import SystemSettingsKit

SystemSettings.open(
    paneIdentifier: "com.apple.Wallpaper-Settings.extension"
)

SystemSettings.open(
    paneIdentifier: "com.apple.settings.PrivacySecurity.extension",
    anchor: "Privacy_Advertising"
)
```

You can also use `SystemSettingsDestination`:

```swift
import SystemSettingsKit

SystemSettings.open(.wallpaper)
SystemSettings.open(.privacy(anchor: .privacyAllFiles))
SystemSettings.open(.displays(anchor: .resolutionSection))
```

## System Settings URL Scheme

`SystemSettingsKit` exposes a lightweight API for opening arbitrary System Settings panes using the `x-apple.systempreferences:` URL scheme.

The behavior and examples are based on the identifiers and deeplink notes collected in [SystemSettings-URLs-macOS](https://github.com/jaywcjlove/SystemSettings-URLs-macOS/blob/main/README.md).

### URL format

```text
x-apple.systempreferences:<pane-identifier>
x-apple.systempreferences:<pane-identifier>?<anchor>
```

Examples:

```text
x-apple.systempreferences:com.apple.Wallpaper-Settings.extension
x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension?Privacy_Advertising
x-apple.systempreferences:com.apple.Wallpaper-Settings.extension?ScreenSaver
```

### Package type

```swift
public struct SystemSettingsDestination {
    public let paneIdentifier: String
    public let anchor: String?
    public var url: URL { get }
}
```

### Convenience destinations

The package includes a few common helpers:

- `.wallpaper`
- `.displays`
- `.displays(anchor:)`
- `.bluetooth`
- `.loginItems`
- `.privacy(anchor:)`

### Privacy anchors

For Privacy & Security subsections, use:

```swift
SystemSettings.open(.privacy(anchor: .privacyAllFiles))
SystemSettings.open(.privacy(anchor: .privacyAdvertising))
SystemSettings.open(.privacy(anchor: .privacyAccessibility))
SystemSettings.open(.privacy(anchor: .security))
```

The existing `PermissionFlowPane` type continues to handle the privacy pages used by the floating authorization workflow.

Available typed privacy anchors and their destinations:

- `.advanced`: `Privacy & Security > Advanced`
- `.fileVault`: `Privacy & Security > FileVault`
- `.locationAccessReport`: `Privacy & Security > Location Access Report`
- `.lockdownMode`: `Privacy & Security > Lockdown Mode`
- `.privacyAccessibility`: `Privacy & Security > Accessibility`
- `.privacyAdvertising`: `Privacy & Security > Advertising`
- `.privacyAllFiles`: `Privacy & Security > Full Disk Access`
- `.privacyAnalytics`: `Privacy & Security > Analytics & Improvements`
- `.privacyAppBundles`: `Privacy & Security > App Management`
- `.privacyAudioCapture`: `Privacy & Security > Audio Capture`
- `.privacyAutomation`: `Privacy & Security > Automation`
- `.privacyBluetooth`: `Privacy & Security > Bluetooth`
- `.privacyCalendars`: `Privacy & Security > Calendars`
- `.privacyCamera`: `Privacy & Security > Camera`
- `.privacyContacts`: `Privacy & Security > Contacts`
- `.privacyDevTools`: `Privacy & Security > Developer Tools`
- `.privacyFilesAndFolders`: `Privacy & Security > Files & Folders`
- `.privacyFocus`: `Privacy & Security > Focus`
- `.privacyHomeKit`: `Privacy & Security > Home`
- `.privacyListenEvent`: `Privacy & Security > Input Monitoring`
- `.privacyLocationServices`: `Privacy & Security > Location Services`
- `.privacyMedia`: `Privacy & Security > Media & Apple Music`
- `.privacyMicrophone`: `Privacy & Security > Microphone`
- `.privacyMotion`: `Privacy & Security > Motion & Fitness`
- `.privacyNudityDetection`: `Privacy & Security > Sensitive Content Warning`
- `.privacyPasskeyAccess`: `Privacy & Security > Passkey Access`
- `.privacyPhotos`: `Privacy & Security > Photos`
- `.privacyReminders`: `Privacy & Security > Reminders`
- `.privacyRemoteDesktop`: `Privacy & Security > Remote Desktop`
- `.privacyScreenCapture`: `Privacy & Security > Screen Recording`
- `.privacySpeechRecognition`: `Privacy & Security > Speech Recognition`
- `.privacySystemServices`: `Privacy & Security > System Services`
- `.security`: `Privacy & Security > Security`
- `.securityImprovements`: `Privacy & Security > Security Improvements`

### Displays anchors

Displays now has a typed helper instead of raw string anchors:

```swift
SystemSettings.open(.displays)
SystemSettings.open(.displays(anchor: .arrangementSection))
SystemSettings.open(.displays(anchor: .resolutionSection))
SystemSettings.open(.displays(anchor: .nightShiftSection))
```

Available display anchors and their destinations:

- `.advancedSection`: `Displays > Advanced`
- `.ambienceSection`: `Displays > Ambience`
- `.arrangementSection`: `Displays > Arrangement`
- `.characteristicSection`: `Displays > Display Characteristics`
- `.displaysSection`: `Displays > Displays`
- `.miscellaneousSection`: `Displays > Miscellaneous`
- `.nightShiftSection`: `Displays > Night Shift`
- `.profileSection`: `Displays > Color Profile`
- `.resolutionSection`: `Displays > Resolution`
- `.sidecarSection`: `Displays > Sidecar`

## Configuration

```swift
let configuration = PermissionFlowConfiguration(
    requiredAppURLs: [Bundle.main.bundleURL],
    promptForAccessibilityTrust: false
)
```

### Notes

- `requiredAppURLs` preloads apps into the panel
- `promptForAccessibilityTrust` controls whether AX trust is actively prompted

## How It Works

1. Your app requests a permission pane.
2. `PermissionFlow` opens the matching `System Settings` page.
3. If that pane supports drag-based authorization, a floating panel appears.
4. The panel animates from the click location to the `System Settings` window.
5. The panel tracks the `System Settings` window position.
6. The user drags the current `.app` bundle into the permission list.

## Example

The repository includes an `Example` macOS app that demonstrates all supported permission flows.

## Notes and Limitations

- The floating helper is only shown for panes that support app-list style authorization.
- `System Settings` behavior is controlled by macOS and may vary slightly by OS version.
- AX-based window tracking is used when available. Window Server frame lookup is used as fallback and bootstrap.
- The package does not bypass macOS security. It only guides the user through the system UI.

## License

MIT
