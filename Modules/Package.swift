// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "AppFeature",
            targets: ["AppFeature"]
        ),
        .library(
            name: "Core",
            targets: ["Core"]
        ),
        .library(
            name: "HostFeature",
            targets: ["HostFeature"]
        ),
        .library(
            name: "PreviewHelpers",
            targets: ["PreviewHelpers"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", .exact("0.33.1")),
    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                "Core",
                "HostFeature",
                "PreviewHelpers",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "Core",
            dependencies: []
        ),
        .target(
            name: "HostFeature",
            dependencies: [
                "PreviewHelpers",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            resources: [
                .process("Models/Resources"),
            ]
        ),
        .target(
            name: "PreviewHelpers",
            dependencies: []
        ),
    ]
)
