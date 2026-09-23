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
            url: "https://github.com/thakur-vijay/NetworkKit/releases/download/1.1.5/NetworkKit.xcframework.zip",
            checksum: "ab0f5d272ec15eb1b39f39e19443cf78c08ee59b54de371bf687c9af1a3372a0"
        )
    ],

    swiftLanguageModes: [.v6]
)
