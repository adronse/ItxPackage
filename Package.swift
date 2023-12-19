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
        .package(url: "https://github.com/apollographql/apollo-ios.git", from: "1.0.0")
    ],
    targets: [
            .target(
                name: "ItxPackage",
                dependencies: ["SnapKit", "apollo-ios"]), // Add SnapKit as a dependency for the target
            .testTarget(
                name: "ItxPackageTests",
                dependencies: ["ItxPackage"]),
        ]
)
 
