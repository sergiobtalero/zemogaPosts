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
        .package(name: "Domain", path: "../Domain"),
        .package(url: "https://github.com/AliSoftware/OHHTTPStubs", .upToNextMajor(from: "9.1.0"))
    ],
    targets: [
        .target(
            name: "Data",
            dependencies: ["Domain"]),
        .testTarget(
            name: "DataTests",
            dependencies: ["Data",
                           .product(name: "OHHTTPStubsSwift", package: "OHHTTPStubs")
            ],
            resources: [
                .copy("JSONS/PostsList.json"),
                .copy("JSONS/User.json")
            ])
    ]
)
