// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PermissionFlow",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "SystemSettingsKit",
            targets: ["SystemSettingsKit"]
        ),
        .library(
            name: "PermissionFlow",
            targets: ["PermissionFlow"]
        ),
    ],
    targets: [
        .target(
            name: "SystemSettingsKit"
        ),
        .target(
            name: "PermissionFlow",
            dependencies: ["SystemSettingsKit"]
        ),
        .testTarget(
            name: "PermissionFlowTests",
            dependencies: ["PermissionFlow", "SystemSettingsKit"]
        ),
    ]
)
