# PermissionFlow

`PermissionFlow` 是一个面向 Apple 平台应用的 Swift Package，包含两个职责明确的子库：

- `PermissionFlow`：仅支持 macOS 的悬浮授权引导库
- `SystemSettingsKit`：用于跳转系统设置页面的强类型 API，支持 macOS，并提供部分 iOS 支持

它会自动打开对应的系统隐私页；对于支持拖拽式授权的权限页，还会显示一个悬浮辅助窗口，跟随 `System Settings` 窗口移动，并允许用户直接把当前 `.app` 拖入授权列表。

## 功能特性

- 自动打开目标 `System Settings` 隐私权限页
- 悬浮窗口从点击位置飞入到 `System Settings` 窗口附近
- 悬浮窗口跟随 `System Settings` 窗口移动
- 悬浮窗口内直接显示当前应用，并提供原生拖拽源
- 全局只保留一个活动悬浮窗口
- `System Settings` 关闭后自动关闭悬浮窗口
- 悬浮窗口高度根据内容自适应

## 运行要求

- macOS 13+
- Swift 6 Package Toolchain
- 宿主应用为 SwiftUI + AppKit macOS 应用

## 安装

在你的项目中添加依赖：

```swift
dependencies: [
    .package(url: "https://github.com/your-org/PermissionFlow.git", from: "1.0.0")
]
```

这个 package 现在提供两个 library product：

- `PermissionFlow`：用于支持悬浮授权引导的权限页
- `SystemSettingsKit`：用于任意 `System Settings` 页面 deeplink 跳转

然后在 target 中按需引入产品：

```swift
.target(
    name: "YourApp",
    dependencies: [
        .product(name: "PermissionFlow", package: "PermissionFlow"),
        .product(name: "SystemSettingsKit", package: "PermissionFlow")
    ]
)
```

平台支持：

- `PermissionFlow`：`macOS 13+`
- `SystemSettingsKit`：`macOS 13+`、`iOS 16+`

其中 `SystemSettingsKit` 在 iOS 上是“部分支持”状态。macOS 那套基于 pane identifier 和 anchor 的 deeplink API 仍然只在 macOS 暴露；iOS 侧只提供 UIKit 公开允许的设置入口，例如当前应用的设置页。

## 支持的权限页面

`PermissionFlow` 只覆盖支持悬浮框 + 拖拽授权的这 4 个权限页：

- `Accessibility`：辅助功能权限。常用于窗口控制、界面自动化、辅助操作等场景，系统会维护一个可添加应用的授权列表。
- `Full Disk Access`：完全磁盘访问权限。适用于需要读取系统级目录、其他应用数据或更广泛文件范围的工具类应用。
- `Input Monitoring`：输入监控权限。用于监听键盘、鼠标等输入事件，常见于快捷键工具、输入增强工具或部分自动化应用。
- `Screen Recording`：屏幕录制权限。用于截屏、录屏、屏幕内容识别或基于屏幕画面的辅助功能场景。

其它所有 `System Settings` 页面或隐私子页面，请使用 `SystemSettingsKit`。

## 快速开始

### 使用 SwiftUI 按钮

```swift
import PermissionFlow
import SwiftUI

struct ContentView: View {
    var body: some View {
        PermissionFlowButton(
            title: "申请辅助功能权限",
            pane: .accessibility,
            suggestedAppURLs: [Bundle.main.bundleURL]
        )
    }
}
```

### 手动使用 Controller

如果你希望自己控制触发时机，可以直接使用 `PermissionFlowController`：

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

### 保留点击到设置窗口的飞入动画

如果你使用 `PermissionFlowButton`，包内部会自动记录点击位置，悬浮框会从点击点飞到 `System Settings` 窗口附近。

如果你是手动调用 `PermissionFlowController.authorize(...)`，就需要自己传入 `sourceFrameInScreen`。否则悬浮框虽然仍然会显示，但会直接跳到目标位置，不会执行这段飞入动画。

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

## 对外 API

### `PermissionFlowButton`

SwiftUI 快捷按钮封装：

```swift
PermissionFlowButton(
    title: "打开屏幕录制权限",
    pane: .screenRecording,
    suggestedAppURLs: [Bundle.main.bundleURL],
    configuration: .init()
)
```

### `PermissionFlow.makeController`

创建一个可复用的控制器：

```swift
let controller = PermissionFlow.makeController(
    configuration: .init(
        requiredAppURLs: [Bundle.main.bundleURL],
        promptForAccessibilityTrust: false
    )
)
```

### `PermissionFlowController`

主要入口：

- `authorize(pane:suggestedAppURLs:sourceFrameInScreen:)`
- `showPanel()`
- `closePanel()`
- `resetDroppedApps()`
- `registerDroppedApp(_:)`

### `SystemSettings.open`

可以通过 `pane identifier` 和可选 `anchor` 直接跳转任意系统设置页面：

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

也可以使用 `SystemSettingsDestination`：

```swift
import SystemSettingsKit

SystemSettings.open(.wallpaper)
SystemSettings.open(.privacy(anchor: .privacyAllFiles))
SystemSettings.open(.displays(anchor: .resolutionSection))
```

## System Settings URL Scheme

`SystemSettingsKit` 提供了一个轻量的通用 API，用于通过 `x-apple.systempreferences:` URL Scheme 跳转任意 `System Settings` 页面。

这一部分规则和示例，参考自 [SystemSettings-URLs-macOS](https://github.com/jaywcjlove/SystemSettings-URLs-macOS/blob/main/README.md) 中整理的 pane identifier 和 deeplink 说明。

### URL 格式

```text
x-apple.systempreferences:<pane-identifier>
x-apple.systempreferences:<pane-identifier>?<anchor>
```

例如：

```text
x-apple.systempreferences:com.apple.Wallpaper-Settings.extension
x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension?Privacy_Advertising
x-apple.systempreferences:com.apple.Wallpaper-Settings.extension?ScreenSaver
```

### 包内类型

```swift
public struct SystemSettingsDestination {
    public let paneIdentifier: String
    public let anchor: String?
    public var url: URL { get }
}
```

### 内置便捷目标

包内提供了一些常见页面的快捷入口：

- `.wallpaper`
- `.displays`
- `.displays(anchor:)`
- `.bluetooth`
- `.loginItems`
- `.privacy(anchor:)`

### 隐私权限锚点

对于“隐私与安全性”中的子页面，可以这样写：

```swift
SystemSettings.open(.privacy(anchor: .privacyAllFiles))
SystemSettings.open(.privacy(anchor: .privacyAdvertising))
SystemSettings.open(.privacy(anchor: .privacyAccessibility))
SystemSettings.open(.privacy(anchor: .security))
```

原有的 `PermissionFlowPane` 仍然继续用于当前包内“带悬浮框授权流程”的那组隐私权限页面。

当前内置的隐私与安全性强类型锚点，以及它们实际跳转到的位置：

- `.advanced`：跳转到 `隐私与安全性 > 高级`
- `.fileVault`：跳转到 `隐私与安全性 > FileVault`
- `.locationAccessReport`：跳转到 `隐私与安全性 > 位置访问报告`
- `.lockdownMode`：跳转到 `隐私与安全性 > 锁定模式`
- `.privacyAccessibility`：跳转到 `隐私与安全性 > 辅助功能`
- `.privacyAdvertising`：跳转到 `隐私与安全性 > 广告`
- `.privacyAllFiles`：跳转到 `隐私与安全性 > 完全磁盘访问`
- `.privacyAnalytics`：跳转到 `隐私与安全性 > 分析与改进`
- `.privacyAppBundles`：跳转到 `隐私与安全性 > App 管理`
- `.privacyAudioCapture`：跳转到 `隐私与安全性 > 音频捕获`
- `.privacyAutomation`：跳转到 `隐私与安全性 > 自动化`
- `.privacyBluetooth`：跳转到 `隐私与安全性 > 蓝牙`
- `.privacyCalendars`：跳转到 `隐私与安全性 > 日历`
- `.privacyCamera`：跳转到 `隐私与安全性 > 摄像头`
- `.privacyContacts`：跳转到 `隐私与安全性 > 通讯录`
- `.privacyDevTools`：跳转到 `隐私与安全性 > 开发者工具`
- `.privacyFilesAndFolders`：跳转到 `隐私与安全性 > 文件与文件夹`
- `.privacyFocus`：跳转到 `隐私与安全性 > 专注模式`
- `.privacyHomeKit`：跳转到 `隐私与安全性 > 家庭`
- `.privacyListenEvent`：跳转到 `隐私与安全性 > 输入监控`
- `.privacyLocationServices`：跳转到 `隐私与安全性 > 定位服务`
- `.privacyMedia`：跳转到 `隐私与安全性 > 媒体与 Apple Music`
- `.privacyMicrophone`：跳转到 `隐私与安全性 > 麦克风`
- `.privacyMotion`：跳转到 `隐私与安全性 > 动作与健身`
- `.privacyNudityDetection`：跳转到 `隐私与安全性 > 敏感内容警告`
- `.privacyPasskeyAccess`：跳转到 `隐私与安全性 > 通行密钥访问`
- `.privacyPhotos`：跳转到 `隐私与安全性 > 照片`
- `.privacyReminders`：跳转到 `隐私与安全性 > 提醒事项`
- `.privacyRemoteDesktop`：跳转到 `隐私与安全性 > 远程桌面`
- `.privacyScreenCapture`：跳转到 `隐私与安全性 > 屏幕录制`
- `.privacySpeechRecognition`：跳转到 `隐私与安全性 > 语音识别`
- `.privacySystemServices`：跳转到 `隐私与安全性 > 系统服务`
- `.security`：跳转到 `隐私与安全性 > 安全性`
- `.securityImprovements`：跳转到 `隐私与安全性 > 安全改进`

### 显示器子页面锚点

现在“显示器”页面也提供了强类型封装，不需要再手写 anchor 字符串：

```swift
SystemSettings.open(.displays)
SystemSettings.open(.displays(anchor: .arrangementSection))
SystemSettings.open(.displays(anchor: .resolutionSection))
SystemSettings.open(.displays(anchor: .nightShiftSection))
```

当前内置的显示器锚点，以及它们实际跳转到的位置：

- `.advancedSection`：跳转到 `显示器 > 高级`
- `.ambienceSection`：跳转到 `显示器 > 氛围显示`
- `.arrangementSection`：跳转到 `显示器 > 排列`
- `.characteristicSection`：跳转到 `显示器 > 显示特性`
- `.displaysSection`：跳转到 `显示器 > 显示器列表`
- `.miscellaneousSection`：跳转到 `显示器 > 其他`
- `.nightShiftSection`：跳转到 `显示器 > 夜览`
- `.profileSection`：跳转到 `显示器 > 色彩配置文件`
- `.resolutionSection`：跳转到 `显示器 > 分辨率`
- `.sidecarSection`：跳转到 `显示器 > Sidecar`

## 配置项

```swift
let configuration = PermissionFlowConfiguration(
    requiredAppURLs: [Bundle.main.bundleURL],
    promptForAccessibilityTrust: false
)
```

### 配置说明

- `requiredAppURLs`：预先注入到悬浮框中的应用
- `promptForAccessibilityTrust`：是否主动请求辅助功能信任

## 工作流程

1. 宿主应用请求某个权限页
2. `PermissionFlow` 自动打开对应的 `System Settings` 页面
3. 如果该权限页支持拖拽式授权，则弹出悬浮辅助窗口
4. 悬浮窗口从点击位置动画飞到 `System Settings` 窗口附近
5. 悬浮窗口持续跟随 `System Settings` 窗口移动
6. 用户把当前 `.app` 拖入系统授权列表

## 示例工程

仓库内包含一个 `Example` macOS 演示项目，覆盖了当前支持的所有权限流程。

## 注意事项

- 悬浮辅助窗口只会在支持拖拽式授权的权限页上出现
- `System Settings` 的具体行为由 macOS 控制，不同系统版本可能存在细微差异
- 当辅助功能权限可用时，包会优先使用 AX 做更精确的窗口跟踪；Window Server 查询作为启动和兜底方案
- 这个包不会绕过 macOS 的系统安全模型，它只是帮助用户更顺畅地完成系统授权流程

## License

MIT
