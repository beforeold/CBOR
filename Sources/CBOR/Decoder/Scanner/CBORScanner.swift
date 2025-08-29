//
//  CBORScanner.swift
//  CBOR
//
//  Created by Khan Winter on 8/24/25.
//

import Foundation

/// # Why Scan?
/// I'd have loved to use a 'pop' method for decoding, where we only decode as data is requested. However, the way
/// Swift's decoding APIs work forces us to be able to be able to do random access for keys in maps, which requires
/// scanning.
///
/// Here we build a map of byte offsets and types to be able to quickly scan through a CBOR blob to find specific
/// indices and keys.
///
/// # Dev Notes
///
/// - This is where we do any indeterminate length validation and rejection. The decoder containers themselves will
///   take either indeterminate or specific lengths and decode them.
@usableFromInline
final class CBORScanner {
    @usableFromInline
    enum ScanError: Error {
        case unexpectedEndOfData
        case invalidMajorType(byte: UInt8, offset: Int)
        case invalidSize(byte: UInt8, offset: Int)
        case expectedMajorType(offset: Int)
        case typeInIndeterminateString(type: MajorType, offset: Int)
        case rejectedIndeterminateLength(type: MajorType, offset: Int)
    }

    // MARK: - Results

    /// After the scanner scans, this contains a map that allows the CBOR data to be scanned for values at arbitrary
    /// positions, keys, etc. The map contents are represented literally as ints for performance but uses the
    /// following map:
    /// ```
    /// enum ScanItem: Int {
    ///     case map // (childCount: Int, mapCount: Int, offset: Int, byteCount: Int)
    ///     case array // (childCount: Int, mapCount: Int, offset: Int, byteCount: Int)
    ///
    ///     case int // (offset: Int, byteCount: Int)
    ///     case string
    ///     case byteString
    ///     case tagged
    ///     case simple (byteCount: Int)
    /// }
    /// ```
    struct Results {
        var map: [Int] = []

        init(dataCount: Int) {
            self.map = []
            map.reserveCapacity(dataCount * 4)
        }

        mutating func recordMapStart(currentByteIndex: Int) -> Int {
            map.append(MajorType.map.intValue)
            map.append(0)
            map.append(map.count + 3)
            map.append(currentByteIndex)
            map.append(currentByteIndex)
            return map.count - 5
        }

        mutating func recordArrayStart(currentByteIndex: Int) -> Int {
            map.append(MajorType.array.intValue)
            map.append(0) // child count
            map.append(map.count + 3) // map count
            map.append(currentByteIndex) // start byte
            map.append(currentByteIndex) // byte count
            return map.count - 5
        }

        mutating func recordEnd(childCount: Int, resultLocation: Int, currentByteIndex: Int) {
            map[resultLocation + 1] = childCount
            map[resultLocation + 2] = map.count - map[resultLocation + 2]
            map[resultLocation + 4] = currentByteIndex - map[resultLocation + 4]
        }

        mutating func recordType(_ type: UInt8, currentByteIndex: Int, length: Int) {
            map.append(Int(type))
            map.append(currentByteIndex)
            map.append(length)
        }

        mutating func recordSimple(_ type: UInt8, currentByteIndex: Int) {
            map.append(Int(type))
            map.append(currentByteIndex)
        }
    }

    var reader: DataReader
    var results: Results
    let options: DecodingOptions

    init(data: DataReader, options: DecodingOptions = DecodingOptions()) {
        self.reader = data
        self.results = Results(dataCount: data.count)
        self.options = options
    }

    // MARK: - Load Values

    func load(at mapIndex: Int) -> DataRegion {
        assert(mapIndex < results.map.count)
        let byte = UInt8(results.map[mapIndex])
        let argument = byte & 0b1_1111
        guard let type = MajorType(rawValue: byte) else {
            fatalError("Invalid type found in map: \(results.map[mapIndex]) at index: \(mapIndex)")
        }
        switch type {
        case .uint, .nint, .bytes, .string, .tagged:
            assert(mapIndex + 1 < results.map.count)
            let location = results.map[mapIndex + 1]
            let length = results.map[mapIndex + 2]
            let slice = reader.slice(location..<(location + length))
            return DataRegion(type: type, argument: argument, childCount: nil, mapOffset: mapIndex, data: slice)
        case .simple:
            let length = simpleLength(UInt8(results.map[mapIndex]))
            let slice: Slice<UnsafeRawBufferPointer>
            if length == 0 {
                slice = reader.slice(0..<0)
            } else {
                let location = results.map[mapIndex + 1] + 1 // skip type & arg byte.
                slice = reader.slice(location..<(location + length))
            }
            return DataRegion(type: type, argument: argument, childCount: nil, mapOffset: mapIndex, data: slice)
        case .array, .map:
            // Map determines the slice size
            let childCount = results.map[mapIndex + 1]
            let location = results.map[mapIndex + 3]
            let length = results.map[mapIndex + 4]
            let slice = reader.slice(location..<(location + length))
            return DataRegion(type: type, argument: argument, childCount: childCount, mapOffset: mapIndex, data: slice)
        }
    }

    // MARK: - Map Navigation

    func firstChildIndex(_ mapIndex: Int) -> Int {
        let byte = UInt8(results.map[mapIndex])
        guard let type = MajorType(rawValue: byte) else {
            fatalError("Invalid type found in map: \(results.map[mapIndex]) at index: \(mapIndex)")
        }
        switch type {
        case .uint, .nint, .bytes, .string, .tagged, .simple:
            fatalError("Can't find child index for non-container type.")
        case .array, .map: // type byte + 4 map values
            return mapIndex + 5
        }
    }

    func siblingIndex(_ mapIndex: Int) -> Int {
        let byte = UInt8(results.map[mapIndex])
        guard let type = MajorType(rawValue: byte) else {
            fatalError("Invalid type found in map: \(results.map[mapIndex]) at index: \(mapIndex)")
        }
        switch type {
        case .uint, .nint, .bytes, .string, .tagged:
            return mapIndex + 3
        case .simple:
            return mapIndex + 2
        case .array, .map: // Map contains the map/array count
            return mapIndex + 5 + results.map[mapIndex + 2]
        }
    }

    // MARK: - Scan

    func scan() throws {
        while !reader.isEmpty {
            let idx = reader.index
            try scanNext()
            assert(idx < reader.index, "Scanner made no forward progress in scan")
        }
    }

    private func scanNext() throws {
        guard let type = reader.peekType(), let raw = reader.peek() else {
            if reader.isEmpty {
                throw ScanError.unexpectedEndOfData
            } else {
                throw ScanError.invalidMajorType(byte: (reader.pop() & 0b1110_0000) >> 5, offset: reader.index - 1)
            }
        }

        switch type {
        case .uint, .nint:
            try scanInt(raw: raw)
        case .bytes:
            try scanBytesOrString(.bytes)
        case .string:
            try scanBytesOrString(.string)
        case .array:
            try scanArray()
        case .map:
            try scanMap()
        case .simple:
            scanSimple(raw: raw)
        case .tagged:
            fatalError()
        }
    }

    // MARK: - Scan Int

    private func scanInt(raw: UInt8) throws {
        let size = try popByteCount()
        let offset = reader.index
        results.recordType(raw, currentByteIndex: offset, length: size)
        guard reader.canRead(size) else { throw ScanError.unexpectedEndOfData }
        reader.pop(size)
    }

    // MARK: - Scan Simple

    private func scanSimple(raw: UInt8) {
        let idx = reader.index
        results.recordSimple(reader.pop(), currentByteIndex: idx)
        reader.pop(simpleLength(raw))
    }

    private func simpleLength(_ arg: UInt8) -> Int {
        switch arg & 0b11111 {
        case 25:
            2 // Half-float
        case 26:
            4 // Float
        case 27:
            8 // Double
        default:
            0 // Just this byte.
        }
    }

    // MARK: - Scan String/Bytes

    private func scanBytesOrString(_ type: MajorType) throws {
        let raw = reader._peek() // already checked previously

        guard peekIsIndeterminate() else {
            let size = try reader.readNextInt(as: Int.self)
            let offset = reader.index
            results.recordType(raw, currentByteIndex: offset, length: size)
            guard reader.canRead(size) else { throw ScanError.unexpectedEndOfData }
            reader.pop(size)
            return
        }

        if (type == .string || type == .bytes) && options.rejectIndeterminateLengths {
            throw ScanError.rejectedIndeterminateLength(type: type, offset: reader.index)
        }

        reader.pop() // Pop type
        let start = reader.index
        // Indeterminate size, loop through real-sized strings until we find the break code.
        while reader.peek() != Constants.breakCode {
            guard let nextType = reader.peekType() else {
                throw ScanError.expectedMajorType(offset: reader.index)
            }
            guard nextType == type else {
                throw ScanError.typeInIndeterminateString(type: nextType, offset: reader.index)
            }

            let size = try reader.readNextInt(as: Int.self)
            guard reader.canRead(size) else { throw ScanError.unexpectedEndOfData }
            reader.pop(size) // Move to the next string
        }
        // Pop the break byte
        guard !reader.isEmpty else { throw ScanError.unexpectedEndOfData } // expected break byte (FF)
        reader.pop()
        results.recordType(raw, currentByteIndex: start, length: reader.index - start)
    }

    // MARK: - Scan Array

    private func scanArray() throws {
        guard peekIsIndeterminate() else {
            let size = try reader.readNextInt(as: Int.self)
            let mapIdx = results.recordArrayStart(currentByteIndex: reader.index)
            for _ in 0..<size {
                try scanNext()
            }
            results.recordEnd(childCount: size, resultLocation: mapIdx, currentByteIndex: reader.index)
            return
        }

        if options.rejectIndeterminateLengths {
            throw ScanError.rejectedIndeterminateLength(type: .array, offset: reader.index)
        }

        let mapIdx = results.recordArrayStart(currentByteIndex: reader.index)
        reader.pop() // Pop type
        var count = 0
        while reader.peek() != Constants.breakCode {
            try scanNext()
            count += 1
        }
        // Pop the break byte
        reader.pop()
        results.recordEnd(childCount: count, resultLocation: mapIdx, currentByteIndex: reader.index)
    }

    // MARK: - Scan Map

    private func scanMap() throws {
        guard peekIsIndeterminate() else {
            let size = try reader.readNextInt(as: Int.self) * 2
            let mapIdx = results.recordMapStart(currentByteIndex: reader.index)
            for _ in 0..<size {
                try scanNext()
            }
            results.recordEnd(childCount: size, resultLocation: mapIdx, currentByteIndex: reader.index)
            return
        }

        if options.rejectIndeterminateLengths {
            throw ScanError.rejectedIndeterminateLength(type: .map, offset: reader.index)
        }

        let mapIdx = results.recordMapStart(currentByteIndex: reader.index)
        reader.pop() // Pop type
        var count = 0
        while reader.peek() != Constants.breakCode {
            try scanNext() // Maps should always have a multiple of two values.
            try scanNext()
            count += 2
        }
        // Pop the break byte
        reader.pop()
        results.recordEnd(childCount: count, resultLocation: mapIdx, currentByteIndex: reader.index)
    }
}

// MARK: - Utils

extension CBORScanner {
    func popByteCount() throws -> Int {
        let byteCount = reader.popArgument()
        return switch byteCount {
        case let value where value < Constants.maxArgSize: 0
        case 24: 1
        case 25: 2
        case 26: 4
        case 27: 8
        default:
            throw ScanError.invalidSize(byte: byteCount, offset: reader.index - 1)
        }
    }

    func peekIsIndeterminate() -> Bool {
        (reader.peekArgument() ?? 0) == 0b1_1111
    }
}

// MARK: - Debug Description

#if DEBUG
extension CBORScanner: CustomDebugStringConvertible {
    @usableFromInline var debugDescription: String {
        var string = ""
        func indent(_ other: String, d: Int) { string += String(repeating: " ", count: d * 2) + other + "\n" }

        func gen(_ idx: Int, depth: Int) {
            let value = load(at: idx)
            switch value.type {
            case .map, .array:
                indent(
                    "\(value.type), mapIdx: \(value.mapOffset), children: \(value.childCount!), bytes: \(value.count)",
                    d: depth
                )
                var idx = firstChildIndex(idx)
                for _ in 0..<value.childCount! {
                    gen(idx, depth: depth + 1)
                    idx = siblingIndex(idx)
                }
            default:
                indent("\(value.type), mapIdx: \(value.mapOffset), arg: \(value.argument)", d: depth)
            }
        }

        gen(0, depth: 0)
        return string
    }
}
#endif
