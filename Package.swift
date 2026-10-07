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
            url: "https://github.com/thakur-vijay/NetworkKit/releases/download/1.1.8/NetworkKit.xcframework.zip",
            checksum: "93fb4b6121a7a8eb6a0d063d002c096aec47b9093981ec38d34db29b3f043ae6"
        )
    ],

    swiftLanguageModes: [.v6]
)
