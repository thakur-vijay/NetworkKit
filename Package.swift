// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "NetworkKit",

    products: [
        .library(
            name: "NetworkKit",
            targets: ["NetworkKit"]
        ),
    ],

    targets: [
        .binaryTarget(
            name: "NetworkKit",
            url: "https://github.com/thakur-vijay/NetworkKit/releases/download/1.2.7/NetworkKit.xcframework.zip",
            checksum: "4beb5ae5fa490edbcae16650c3d6428f38ef531f938d0391495eb111f8f02bca"
        )
    ],

    swiftLanguageModes: [.v6]
)
