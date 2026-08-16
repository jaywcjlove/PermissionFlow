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
            name: "PermissionFlowStatusStore",
            targets: ["PermissionFlowStatusStore"]
        ),
        .library(
            name: "PermissionFlowBluetoothStatus",
            targets: ["PermissionFlowBluetoothStatus"]
        ),
        .library(
            name: "PermissionFlowCameraStatus",
            targets: ["PermissionFlowCameraStatus"]
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
            name: "PermissionFlowStatusStore",
            dependencies: ["PermissionFlow"],
            path: "Sources/PermissionFlowStatusStore"
        ),
        .target(
            name: "PermissionFlowBluetoothStatus",
            dependencies: ["PermissionFlow"],
            path: "Sources/PermissionFlowBluetoothStatus"
        ),
        .target(
            name: "PermissionFlowCameraStatus",
            dependencies: ["PermissionFlow"],
            path: "Sources/PermissionFlowCameraStatus"
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
                "PermissionFlowCameraStatus",
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
                "PermissionFlowStatusStore",
                "PermissionFlowExtendedStatus"
            ]
        ),
    ]
)
