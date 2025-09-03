

<p align="center">
  <img src="https://github.com/thecoolwinter/CBOR/blob/main/.github/Icon-256.png?raw=true" height="128">
  <h1 align="center">CBOR</h1>
</p>

[CBOR](https://cbor.io/) is a flexible data format that emphasizes extremely small code size, small message size, and extendability. This library provides a Swift API for encoding and decoding Swift types using the CBOR serialization format. 

The motivation for this library over existing implementations is twofold: performance, and reliability. Existing community implementations do not make correct use of Swift features like `Optional` and memory safety. This library aims to be safe while still outperforming other implementations. To that end, this library has been extensively [fuzz tested](./Fuzzing.md) to ensure your application never crashes due to malicious input. At the same time, this library boasts up to a *74% faster* encoding and up to *89% faster* decoding than existing implementations. See [benchmarks](#benchmarks) for more details.

## Usage

This library utilizes Swift's `Codable` API for all (de)serialization operations. It intentionally doesn't support streaming CBOR blobs. After [installing](#installation) the package using Swift Package Manager, use the `CBOREncoder` and `CBORDecoder` types to encode to and decode from CBOR blobs, respectively.

```swift
// Encode any `Encodable` value.
let encoder = CBOREncoder()
try encoder.encode(0) // Result: 0x00
try encoder.encode([404: "Not Found"]) // Result: 0xA1190194694E6F7420466F756E64

// Decode any `Decodable` type.
let decoder = CBORDecoder()
let intValue = try decoder.decode(Int.self, from: Data([0])) // Result: 0
// Result: ["AB": 1, "A": 2]
let mapValue = try decoder.decode([String: Int].self.self, from: Data([162, 98, 65, 66, 1, 97, 65, 2]))
```

The encoder and decoders can be customized via the en/decoder initializers or via a `En/DecodingOptions` struct.

```swift
// Customize encoder behavior.
let encoder = CBOREncoder(
	forceStringKeys: Bool = false,
    dateEncodingStrategy: EncodingOptions.DateStrategy = .double
)
// or via the options struct
let options = EncodingOptions(/* ... */)
let encoder = CBOREncoder(options: options)

// Customize the decoder behavior, such as enforcing deterministic CBOR.
let decoder = CBORDecoder(rejectIndeterminateLengths: Bool = false)
// or via the options struct
let options = DecodingOptions(/* ... */)
let decoder = CBORDecoder(options: options)
```

[Documentation]() is hosted on the Swift Package Index.

## Installation

You can use the Swift Package Manager to download and import the library into your project:

```swift
dependencies: [
    .package(url: "https://github.com/thecoolwinter/CBOR.git", from: "1.0.0")
]
```

Then under `targets`:

```swift
targets: [
    .target(
    	// ...
        dependencies: [
            .product(name: "CBOR", package: "CBOR")
        ]
    )
]
```

## Benchmarks

These benchmarks range from simple to complex encoding and decoding operations compared to the [SwiftCBOR](https://github.com/valpackett/SwiftCBOR) library. [Benchmarks source](./Benchmarks). Benchmarks are run on 10,000 samples and the p50 values are compared here.

### Decoding (cpu time)

| Benchmark | SwiftCBOR (ns, p50) | CBOR (ns, p50) | % Improvement |
|-----------|----------------|-----------|------------|
| Array | 23 | 7 | **69.57%** |
| Complex Object | 700,000 | 74,000 | **89.43%** |
| Date | 5,211 | 1,042 | **80.00%** |
| Dictionary | 17 | 5 | **70.59%** |
| Double | 5,251 | 1,000 | **80.96%** |
| Float | 5,251 | 1,000 | **80.96%** |
| Indeterminate String | 6,251 | 1,375 | **78.00%** |
| Int | 5,211 | 1,124 | **78.43%** |
| Int Small | 5,167 | 1,083 | **79.04%** |
| Simple Object | 36 | 8 | **77.78%** |
| String | 5,419 | 1,251 | **76.91%** |
| String Small | 5,251 | 1,125 | **78.58%** |

### Encoding (cpu time)

| Benchmark | SwiftCBOR (ns, p50) | CBOR (ns, p50) | % Improvement |
|-----------|----------------|-----------|------------|
| Array | 666,000 | 471,000 | **29.28%** |
| Array Small | 7,003 | 2,875 | **58.95%** |
| Bool | 3,167 | 1,124 | **64.51%** |
| Complex Codable Object | 124,000 | 92,000 | **25.81%** |
| Data | 5,295 | 1,208 | **77.19%** |
| Data Small | 3,917 | 959 | **75.52%** |
| Dictionary | 11 | 5 | **54.55%** |
| Dictionary Small | 7,419 | 2,875 | **61.25%** |
| Int | 3,959 | 1,291 | **67.39%** |
| Int Small | 3,793 | 1,208 | **68.15%** |
| Simple Codable Object | 18 | 9 | **50.00%** |
| String | 5,543 | 1,250 | **77.45%** |
| String Small | 4,001 | 1,125 | **71.88%** |

## Contributing

By participating in this project you agree to follow the [Contributor Code of Conduct](https://contributor-covenant.org/version/1/4/). Pull requests and issues are welcome!

## Sponsor

This project has been developed in my spare time. To keep me motivated to continue to maintain it into the future, consider [supporting my work](https://github.com/sponsors/thecoolwinter)!
