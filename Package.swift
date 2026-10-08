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
            url: "https://github.com/thakur-vijay/NetworkKit/releases/download/1.2.1/NetworkKit.xcframework.zip",
            checksum: "ce0d662207b2c41d7bd772018598f01ffa02375214b9bbc8b87bd46566996006"
        )
    ],

    swiftLanguageModes: [.v6]
)
