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
            url: "https://github.com/thakur-vijay/NetworkKit/releases/download/1.2.6/NetworkKit.xcframework.zip",
            checksum: "1a18af9ba041d51cc5bdd09c494952771a3e73a7221182db4be46738cbbbf71d"
        )
    ],

    swiftLanguageModes: [.v6]
)
