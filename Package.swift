// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "CBOR",
    products: [
        .library(name: "CBOR", targets: ["CBOR"])
    ],
    dependencies: [
        // Heap
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.2.0"),
    ],
    targets: [
        .target(
            name: "CBOR",
            dependencies: [
                .product(name: "Collections", package: "swift-collections")
            ]
        ),
        .testTarget(
            name: "CBORTests",
            dependencies: ["CBOR"],
        )
    ]
)
