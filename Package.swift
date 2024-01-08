// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ItxPackage",
    platforms: [
        .macOS(.v10_14), // Set the macOS deployment target version
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ItxPackage",
            targets: ["ItxPackage"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.6.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/RxSwiftCommunity/RxAlamofire.git",
                           from: "6.1.0"),
    ],
    targets: [
        .target(
            name: "ItxPackage",
            dependencies: [
                "SnapKit",
                "RxSwift",
                "RxAlamofire"
            ]
        ),
        .testTarget(
            name: "ItxPackageTests",
            dependencies: ["ItxPackage"]),
    ]
)
