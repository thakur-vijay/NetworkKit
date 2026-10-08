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
            url: "https://github.com/thakur-vijay/NetworkKit/releases/download/1.2.2/NetworkKit.xcframework.zip",
            checksum: "bf98817ad4e0562b0579c1f8a4f80bd2eeae2ace0bb66b8196a4e17c8bfee94a"
        )
    ],

    swiftLanguageModes: [.v6]
)
