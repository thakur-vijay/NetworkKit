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
            url: "https://github.com/thakur-vijay/NetworkKit/releases/download/1.1.6/NetworkKit.xcframework.zip",
            checksum: "dfe85b69362208bb87d05fc8ac72b173f1e13e401172038da731e5e209e8ffe6"
        )
    ],

    swiftLanguageModes: [.v6]
)
