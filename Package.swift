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
            url: "https://github.com/thakur-vijay/NetworkKit/releases/download/1.2.0/NetworkKit.xcframework.zip",
            checksum: "383c36fbcf182b11583f85b24900030dce88f59396570e8a01578dc8defbfa40"
        )
    ],

    swiftLanguageModes: [.v6]
)
