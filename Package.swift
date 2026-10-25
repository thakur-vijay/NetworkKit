// swift-tools-version: 6.2

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
            url: "https://github.com/thakur-vijay/NetworkKit/releases/download/1.2.5/NetworkKit.xcframework.zip",
            checksum: "f396bcd8c0d6ed4c2c21a700e50515d21ce194aed0fd28f8647c224781e15d92"
        )
    ],

    swiftLanguageModes: [.v6]
)
