//
//  SingleValueCBORDecodingContainer.swift
//  CBOR
//
//  Created by Khan Winter on 8/20/25.
//

import Foundation

struct SingleValueCBORDecodingContainer: DecodingContextContainer {
    let context: DecodingContext
    let data: DataRegion
}

extension SingleValueCBORDecodingContainer: Decoder {
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
        try KeyedDecodingContainer(KeyedCBORDecodingContainer(context: context, data: data))
    }

    func unkeyedContainer() throws -> any UnkeyedDecodingContainer {
        try UnkeyedCBORDecodingContainer(context: context, data: data)
    }

    func singleValueContainer() throws -> any SingleValueDecodingContainer {
        self
    }
}

extension SingleValueCBORDecodingContainer: SingleValueDecodingContainer {
    func decodeNil() -> Bool {
        data.isNil()
    }

    func decode(_: Bool.Type) throws -> Bool {
        let argument = try checkType(.simple, arguments: 20, 21, as: Bool.self)
        return argument == 21
    }

    func decode(_: Float.Type) throws -> Float {
        try checkType(.simple, arguments: 26, as: Float.self)
        let floatRaw = try data.read(as: UInt32.self)
        return Float(bitPattern: floatRaw)
    }

    func decode(_: Double.Type) throws -> Double {
        try checkType(.simple, arguments: 27, as: Double.self)
        let doubleRaw = try data.read(as: UInt64.self).littleEndian
        return Double(bitPattern: doubleRaw)
    }

    func decode<T: Decodable & FixedWidthInteger>(_: T.Type) throws -> T {
        try checkType(.uint, .nint)
        let value = try data.readInt(as: T.self)
        if data.type == .nint {
            return -1 - value
        }
        return value
    }

    func decode(_: String.Type) throws -> String {
        try checkType(.string)

        if data.argument == Constants.indeterminateArg {
            return try decodeIndeterminateString()
        }

        let length = data.count
        if length == 0 {
            return ""
        }

        guard data.canRead(length) else {
            throw DecodingError.valueNotFound(Bool.self, context.error("Unexpected end of data"))
        }
        let bytes = data[0..<length]
        guard let string = String(data: Data(bytes), encoding: .utf8) else {
            throw DecodingError.dataCorrupted(context.error("Failed to decode valid UTF8 string."))
        }
        return string
    }

    private func decodeIndeterminateString() throws -> String {
        // Collect strings until we're done
        var idx = 0
        var string = ""
        while idx < data.count && data[idx] != Constants.breakCode {
            let slice = data[(idx + 1)..<data.count]
            let argument = data[idx] & 0b11111
            let size = try slice.readInt(as: Int.self, argument: argument)

            idx += 1

            guard let byteCount = argument.byteCount() else {
                throw CBORScanner.ScanError.invalidSize(byte: argument, offset: data.globalIndex)
            }

            let utf8Start = idx + Int(byteCount)
            let utf8Slice = data[utf8Start..<(utf8Start + size)]

            guard let substring = String(data: Data(utf8Slice), encoding: .utf8) else {
                throw DecodingError.dataCorrupted(
                    context.error("Failed to decode UTF8 string in \(utf8Start..<(utf8Start + size))")
                )
            }

            string += substring
            idx = utf8Start + size
        }
        return string
    }

    private func _decode(_: Date.Type) throws -> Date {
        // Will pop this first byte.
        let argument = try checkType(.tagged, arguments: 0, 1, as: Date.self)
        if argument == 0 {
            // String
            return try decodeStringDate()
        } else {
            return try decodeEpochDate()
        }
    }

    private func decodeStringDate() throws -> Date {
        let string = try decode(String.self)
        guard let date = ISO8601DateFormatter().date(from: string) else {
            throw DecodingError.dataCorrupted(context.error("Failed to decode date from \"\(string)\""))
        }
        return date
    }

    private func decodeEpochDate() throws -> Date {
        // Epoch Timestamp, can be a floating point or positive/negative integer value
        switch data.type {
        case .uint:
            let int = try data.readInt(as: UInt.self)
            return Date(timeIntervalSince1970: Double(int))
        case .nint:
            let int = -1 - (try data.readInt(as: Int.self))
            return Date(timeIntervalSince1970: Double(int))
        case .simple:
            switch data.argument {
            case 26:
                // Float
                let float = try decode(Float.self)
                return Date(timeIntervalSince1970: Double(float))
            case 27:
                // Double
                let double = try decode(Double.self)
                return Date(timeIntervalSince1970: double)
            default:
                throw DecodingError.typeMismatch(
                    Date.self,
                    context.error("Could not find valid data type for Epoch Date.")
                )
            }
        default:
            throw DecodingError.typeMismatch(
                Date.self,
                context.error("Could not find valid data type for Epoch Date.")
            )
        }
    }

    private func _decode(_: UUID.Type) throws -> UUID {
        try checkType(.tagged, arguments: 24, as: UUID.self)
        guard data.canRead(17) else { // UUID size + tag
            throw DecodingError.valueNotFound(Bool.self, context.error("Unexpected end of data"))
        }
        let data = data[1..<17]
        return data.withUnsafeBytes { ptr in ptr.load(as: UUID.self) }
    }

    private func _decode(_: Data.Type) throws -> Data {
        try checkType(.string)

        if data.argument == Constants.indeterminateArg {
            return try decodeIndeterminateData()
        }

        let length = data.count
        if length == 0 {
            return Data()
        }

        guard data.canRead(length) else {
            throw DecodingError.valueNotFound(Bool.self, context.error("Unexpected end of data"))
        }
        let bytes = data[0..<length]
        return Data(bytes)
    }

    private func decodeIndeterminateData() throws -> Data {
        // Collect strings until we're done
        var idx = 0
        var string = Data()
        while idx < data.count && data[idx] != Constants.breakCode {
            let slice = data[(idx + 1)..<data.count]
            let argument = data[idx] & 0b11111
            let size = try slice.readInt(as: Int.self, argument: argument)

            idx += 1

            guard let byteCount = argument.byteCount() else {
                throw CBORScanner.ScanError.invalidSize(byte: argument, offset: data.globalIndex)
            }

            let substringStart = idx + Int(byteCount)
            let substringSlice = data[substringStart..<(substringStart + size)]

            let substring = Data(substringSlice)
            string += substring
            idx = substringStart + size
        }
        return string
    }

    func decode<T: Decodable>(_ type: T.Type) throws -> T {
        // swiftlint:disable force_cast
        return if T.self == Date.self {
            try _decode(Date.self) as! T // Unfortunate force unwrap, but necessary
        } else if T.self == UUID.self {
            try _decode(UUID.self) as! T
        } else if T.self == Data.self {
            try _decode(Data.self) as! T
        } else {
            try T(from: self)
        }
        // swiftlint:enable force_cast
    }
}
