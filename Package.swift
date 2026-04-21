// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PermissionFlow",
    defaultLocalization: "en",
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
        .library(
            name: "PermissionFlowBluetoothStatus",
            targets: ["PermissionFlowBluetoothStatus"]
        ),
        .library(
            name: "PermissionFlowMediaStatus",
            targets: ["PermissionFlowMediaStatus"]
        ),
        .library(
            name: "PermissionFlowInputMonitoringStatus",
            targets: ["PermissionFlowInputMonitoringStatus"]
        ),
        .library(
            name: "PermissionFlowScreenRecordingStatus",
            targets: ["PermissionFlowScreenRecordingStatus"]
        ),
        .library(
            name: "PermissionFlowExtendedStatus",
            targets: ["PermissionFlowExtendedStatus"]
        ),
    ],
    targets: [
        .target(
            name: "SystemSettingsKit"
        ),
        .target(
            name: "PermissionFlow",
            dependencies: ["SystemSettingsKit"],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "PermissionFlowBluetoothStatus",
            dependencies: ["PermissionFlow"],
            path: "Sources/PermissionFlowBluetoothStatus"
        ),
        .target(
            name: "PermissionFlowMediaStatus",
            dependencies: ["PermissionFlow"],
            path: "Sources/PermissionFlowMediaStatus"
        ),
        .target(
            name: "PermissionFlowInputMonitoringStatus",
            dependencies: ["PermissionFlow"],
            path: "Sources/PermissionFlowInputMonitoringStatus"
        ),
        .target(
            name: "PermissionFlowScreenRecordingStatus",
            dependencies: ["PermissionFlow"],
            path: "Sources/PermissionFlowScreenRecordingStatus"
        ),
        .target(
            name: "PermissionFlowExtendedStatus",
            dependencies: [
                "PermissionFlowBluetoothStatus",
                "PermissionFlowMediaStatus",
                "PermissionFlowInputMonitoringStatus",
                "PermissionFlowScreenRecordingStatus"
            ],
            path: "Sources/PermissionFlowExtendedStatus"
        ),
        .testTarget(
            name: "PermissionFlowTests",
            dependencies: [
                "PermissionFlow",
                "SystemSettingsKit",
                "PermissionFlowExtendedStatus"
            ]
        ),
    ]
)
