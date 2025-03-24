// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "overlay-container",
    platforms: [.iOS(.v12)],
    products: [
        .library(name: "OverlayContainer", targets: ["OverlayContainer"]),
    ],
    targets: [
        .target(name: "OverlayContainer"),
        .testTarget(name: "OverlayContainerTests", dependencies: ["OverlayContainer"]),
    ]
)
