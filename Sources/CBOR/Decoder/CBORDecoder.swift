//
//  CBORDecoder.swift
//  CBOR
//
//  Created by Khan Winter on 8/20/25.
//

import Foundation

/// Decodes ``Decodable`` objects from CBOR data.
///
/// This type can be reused efficiently for multiple deserialization operations. Use the ``decode(_:from:)`` method
/// to decode data.
///
/// To configure decoding behavior, pass options to the ``init(rejectIndeterminateLengths:)`` method or modify
/// the ``options`` variable.
public struct CBORDecoder {
    /// The options that determine decoding behavior.
    public var options: DecodingOptions

    /// Creates a new decoder.
    /// - Parameter rejectIndeterminateLengths: Set to `false` to allow indeterminate length objects to be decoded.
    ///                                         Defaults to *rejecting* indeterminate length items (strings, bytes,
    ///                                         maps, and arrays).
    public init(rejectIndeterminateLengths: Bool = true) {
        self.options = DecodingOptions(rejectIndeterminateLengths: rejectIndeterminateLengths)
    }

    /// Decodes the given type from CBOR binary data.
    /// - Parameters:
    ///   - type: The decodable type to deserialize.
    ///   - data: The CBOR data to decode from.
    /// - Returns: An instance of the decoded type.
    /// - Throws: A ``DecodingError`` with context and a debug description for a failed deserialization operation.
    public func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try data.withUnsafeBytes {
                let data = $0[...]
                let reader = DataReader(data: data)
                let scanner = CBORScanner(data: reader, options: options)
                try scanner.scan()

                let context = DecodingContext(scanner: scanner)
                let region = scanner.load(at: 0)

                return try SingleValueCBORDecodingContainer(context: context, data: region).decode(T.self)
            }
        } catch {
            if let error = error as? CBORScanner.ScanError {
                switch error {
                case .unexpectedEndOfData:
                    throw DecodingError.dataCorrupted(
                        .init(codingPath: [], debugDescription: "Unexpected end of data.")
                    )
                case let .invalidMajorType(byte, offset):
                    throw DecodingError.dataCorrupted(.init(
                        codingPath: [],
                        debugDescription: "Unexpected major type: \(String(byte, radix: 2)) at offset \(offset)"
                    ))
                case let .invalidSize(byte, offset):
                    throw DecodingError.dataCorrupted(.init(
                        codingPath: [],
                        debugDescription: "Unexpected size argument: \(String(byte, radix: 2)) at offset \(offset)"
                    ))
                case let .expectedMajorType(offset):
                    throw DecodingError.dataCorrupted(.init(
                        codingPath: [],
                        debugDescription: "Expected major type at offset \(offset)"
                    ))
                case let .typeInIndeterminateString(type, offset):
                    throw DecodingError.dataCorrupted(.init(
                        codingPath: [],
                        debugDescription: "Unexpected major type in indeterminate \(type) at offset \(offset)"
                    ))
                case let .rejectedIndeterminateLength(type, offset):
                    throw DecodingError.dataCorrupted(.init(
                        codingPath: [],
                        debugDescription: "Rejected indeterminate length type \(type) at offset \(offset)"
                    ))
                }
            } else {
                throw error
            }
        }
    }
}
