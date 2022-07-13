// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Data",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Data",
            targets: ["Data"]),
    ],
    dependencies: [
        .package(name: "Domain", path: "../Domain")
    ],
    targets: [
        .target(
            name: "Data",
            dependencies: ["Domain"]),
        .testTarget(
            name: "DataTests",
            dependencies: ["Data"],
            resources: [
//                .copy("../../Sources/Data/Persistence/ZemogaPosts.momd"),
                .copy("JSONS/PostsList.json")
            ])
    ]
)
