// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SandboxDrop",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "SandboxDrop",
            targets: ["SandboxDrop"]
        ),
    ],
    targets: [
        .target(
            name: "SandboxDrop"
        ),
        .testTarget(
            name: "SandboxDropTests",
            dependencies: ["SandboxDrop"]
        ),
    ]
)
