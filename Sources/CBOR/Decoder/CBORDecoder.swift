//
//  CBORDecoder.swift
//  CBOR
//
//  Created by Khan Winter on 8/20/25.
//

#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

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

    /// Create a new CBOR decoder.
    /// - Parameter rejectIndeterminateLengths: Set to `false` to allow indeterminate length objects to be decoded.
    ///                                         Defaults to *rejecting* indeterminate length items (strings, bytes,
    ///                                         maps, and arrays).
    public init(rejectIndeterminateLengths: Bool = true) {
        self.options = DecodingOptions(rejectIndeterminateLengths: rejectIndeterminateLengths)
    }

    /// Create a new CBOR decoder
    /// - Parameter options: The decoding options to use.
    public init(options: DecodingOptions) {
        self.options = options
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
                let results = try scanner.scan()

                guard !results.isEmpty else {
                    throw ScanError.unexpectedEndOfData
                }

                let context = DecodingContext(options: options, results: results)
                let region = results.load(at: 0)

                return try SingleValueCBORDecodingContainer(context: context, data: region).decode(T.self)
            }
        } catch {
            if let error = error as? ScanError {
                try throwScanError(error)
            } else {
                throw error
            }
        }
    }

    /// Decodes multiple instances of the given type from CBOR binary data.
    ///
    /// Some BLOBs are made up of multiple CBOR-encoded datas concatenated without valid CBOR dividers (eg in an array
    /// container). This method decodes that kind of data. It will attempt to decode an instance of the given type,
    /// once done, if there's more data, it will continue to attempt to decode more instances.
    ///
    /// - Parameters:
    ///   - type: The decodable type to deserialize.
    ///   - data: The CBOR data to decode from.
    /// - Returns: An instance of the decoded type.
    /// - Throws: A ``DecodingError`` with context and a debug description for a failed deserialization operation.
    public func decodeMultiple<T: Decodable>(_ type: T.Type, from data: Data) throws -> [T] {
        do {
            return try data.withUnsafeBytes {
                let data = $0[...]
                let reader = DataReader(data: data)
                let scanner = CBORScanner(data: reader, options: options)
                let results = try scanner.scan()

                guard !results.isEmpty else {
                    throw ScanError.unexpectedEndOfData
                }

                let context = DecodingContext(options: options, results: results)
                var nextRegion: DataRegion? = results.load(at: 0)

                var accumulator: [T] = []

                while let region = nextRegion {
                    let value = try SingleValueCBORDecodingContainer(context: context, data: region).decode(T.self)
                    accumulator.append(value)
                    let nextMapIndex = results.siblingIndex(region.mapOffset)
                    if nextMapIndex < results.count {
                        nextRegion = results.load(at: results.siblingIndex(region.mapOffset))
                    } else {
                        nextRegion = nil
                    }
                }

                return accumulator
            }
        } catch {
            if let error = error as? ScanError {
                try throwScanError(error)
            } else {
                throw error
            }
        }
    }

    private func throwScanError(_ error: ScanError) throws -> Never {
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
        case let .cannotRepresentInt(max, found, offset):
            throw DecodingError.dataCorrupted(
                .init(
                    codingPath: [],
                    debugDescription: "Failed to decode integer with maximum \(max), "
                    + "found \(found) at \(offset)"
                )
            )
        case .noTagInformation, .invalidMajorTypeForTaggedItem:
            throw error // rethrow these guys
        }
    }
}
