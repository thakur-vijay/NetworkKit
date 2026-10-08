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
            url: "https://github.com/thakur-vijay/NetworkKit/releases/download/1.1.9/NetworkKit.xcframework.zip",
            checksum: "3cc4d8339f4cc32d64fddaef94fd19c745b4063f49c6e1c6cdac5b67e58d84b1"
        )
    ],

    swiftLanguageModes: [.v6]
)
