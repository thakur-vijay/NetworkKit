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
            url: "https://github.com/thakur-vijay/NetworkKit/releases/download/1.2.4/NetworkKit.xcframework.zip",
            checksum: "b3155ad949286ca1af264918f8b0386161747ddf7a7677d840964cca59593c60"
        )
    ],

    swiftLanguageModes: [.v6]
)
