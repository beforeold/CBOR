// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Benchmarks",
    dependencies: [
        .package(path: ".."),
        .package(url: "https://github.com/valpackett/SwiftCBOR.git", branch: "master"),
    ],
    targets: [
        .executableTarget(
            name: "Benchmarks",
            dependencies: [
                "CBOR",
                .product(name: "SwiftCBOR", package: "SwiftCBOR"),
            ]
        ),
    ],
)
