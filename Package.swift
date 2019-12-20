// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Yoke",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "Yoke",
            targets: ["Yoke"])
    ],
    targets: [
        .target(
            name: "Yoke",
            dependencies: []),
        .testTarget(
            name: "YokeTests",
            dependencies: ["Yoke"])
    ]
)
