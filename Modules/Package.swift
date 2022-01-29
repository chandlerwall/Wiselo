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
            name: "DesignLanguage",
            targets: ["DesignLanguage"]
        ),
        .library(
            name: "HostFeature",
            targets: ["HostFeature"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", .exact("0.33.1")),
    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                "HostFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(
            name: "AppFeatureTests",
            dependencies: [
                "AppFeature",
            ]
        ),
        .target(
            name: "Core",
            dependencies: []
        ),
        .target(
            name: "DesignLanguage",
            dependencies: [
                "Core",
            ]
        ),
        .target(
            name: "HostFeature",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            resources: [
                .process("Resources"),
            ]
        ),
    ]
)
