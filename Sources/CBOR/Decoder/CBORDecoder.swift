//
//  CBORDecoder.swift
//  CBOR
//
//  Created by Khan Winter on 8/20/25.
//

import Foundation

public struct CBORDecoder {
    var options: DecodingOptions

    public init(options: DecodingOptions = DecodingOptions()) {
        self.options = options
    }

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
                    throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Unexpected end of data."))
                case .invalidMajorType(let byte, let offset):
                    throw DecodingError.dataCorrupted(.init(
                        codingPath: [],
                        debugDescription: "Unexpected major type: \(String(byte, radix: 2)) at offset \(offset)"
                    ))
                case .invalidSize(let byte, let offset):
                    throw DecodingError.dataCorrupted(.init(
                        codingPath: [],
                        debugDescription: "Unexpected size argument: \(String(byte, radix: 2)) at offset \(offset)"
                    ))
                case .expectedMajorType(let offset):
                    throw DecodingError.dataCorrupted(.init(
                        codingPath: [],
                        debugDescription: "Expected major type at offset \(offset)"
                    ))
                case .typeInIndeterminateString(let type, let offset):
                    throw DecodingError.dataCorrupted(.init(
                        codingPath: [],
                        debugDescription: "Unexpected major type in indeterminate \(type) at offset \(offset)"
                    ))
                case .rejectedIndeterminateLength(let type, let offset):
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
