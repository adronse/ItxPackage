// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ItxPackage",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ItxPackage",
            targets: ["ItxPackage"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.6.0"),
        .package(url: "https://github.com/apollographql/apollo-ios.git", .upToNextMajor(from: "0.43.0"))
    ],
    targets: [
            .target(
                name: "ItxPackage",
                dependencies: ["SnapKit", "apollo-ios"]),
            .target(name: "ApolloCombine", dependencies: [
                .product(name: "Apollo", package: "Apollo")
            ]),
            .testTarget(
                name: "ItxPackageTests",
                dependencies: ["ItxPackage"]),
        ]
)
