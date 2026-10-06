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
            url: "https://github.com/thakur-vijay/NetworkKit/releases/download/1.1.7/NetworkKit.xcframework.zip",
            checksum: "1e8503c982e91f0fc234509763f99cffe95a33e483850ed3513ef9f91a7cf049"
        )
    ],

    swiftLanguageModes: [.v6]
)
