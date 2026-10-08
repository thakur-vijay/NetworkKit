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
            url: "https://github.com/thakur-vijay/NetworkKit/releases/download/1.2.3/NetworkKit.xcframework.zip",
            checksum: "2a0bb80da2dbe7cf19b20ee7062f2e8082ead2338a9cbdba3041c7018988ec14"
        )
    ],

    swiftLanguageModes: [.v6]
)
