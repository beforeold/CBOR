//
//  DataRegion.swift
//  CBOR
//
//  Created by Khan Winter on 8/24/25.
//

struct PlainDataRegion {
    private let data: Slice<UnsafeRawBufferPointer>

    init(data: Slice<UnsafeRawBufferPointer>) {
        self.data = data
    }

    var count: Int { data.count }
    var isEmpty: Bool { data.isEmpty }

    @inlinable
    subscript(index: Int) -> UInt8 {
        data[data.startIndex + index]
    }
}

struct DataRegion {
    let type: MajorType
    let argument: UInt8
    let childCount: Int?
    let mapOffset: Int
    // Does not include the type and argument byte
    private let data: Slice<UnsafeRawBufferPointer>

    var count: Int { data.count }
    var isEmpty: Bool { data.isEmpty }
    var globalIndex: Int { data.startIndex }

    init(type: MajorType, argument: UInt8, childCount: Int?, mapOffset: Int, data: Slice<UnsafeRawBufferPointer>) {
        self.type = type
        self.argument = argument
        self.childCount = childCount
        self.mapOffset = mapOffset
        self.data = data
    }

    @inlinable
    subscript(index: Int) -> UInt8 {
        data[data.startIndex + index]
    }

    subscript(range: Range<Int>) -> Slice<UnsafeRawBufferPointer> {
        data[(data.startIndex + range.lowerBound)..<(data.startIndex + range.upperBound)]
    }

    @inline(__always)
    func canRead(_ numBytes: Int) -> Bool {
        data.canRead(numBytes)
    }

    func _peek() -> UInt8 {
        data[data.startIndex]
    }

    func peek() -> UInt8? {
        guard !isEmpty else { return nil }
        return _peek()
    }

    func isNil() -> Bool {
        // This shouldn't modify the data stack. We just peek here.
        type == .simple && argument == 22
    }

    /// Reads the next variable-sized integer off the data stack.
    @inlinable
    func readInt<T: FixedWidthInteger>(as: T.Type) throws -> T {
        try data.readInt(as: T.self, argument: argument)
    }

    @inlinable
    func read<F: FixedWidthInteger>(as: F.Type) throws -> F {
        try data.read(as: F.self)
    }
}

internal extension Slice<UnsafeRawBufferPointer> {
    @inline(__always)
    @inlinable
    func canRead(_ numBytes: Int) -> Bool {
        count >= numBytes
    }

    @inlinable
    func readInt<T: FixedWidthInteger>(as: T.Type, argument: UInt8) throws -> T {
        let byteCount = argument
        return switch byteCount {
        case let value where value < Constants.maxArgSize:
            T(value)
        case 24:
            T(try read(as: UInt8.self))
        case 25:
            T(try read(as: UInt16.self))
        case 26:
            T(try read(as: UInt32.self))
        case 27:
            T(try read(as: UInt64.self))
        default:
            throw CBORScanner.ScanError.invalidSize(byte: byteCount, offset: startIndex)
        }
    }

    @inlinable
    func read<F: FixedWidthInteger>(as: F.Type) throws -> F {
        guard canRead(F.byteCount) else {
            throw CBORScanner.ScanError.unexpectedEndOfData
        }
        var val = F.zero
        for idx in 0..<(F.byteCount) {
            let shift = (F.byteCount - idx - 1) * 8
            val |= F(self[startIndex + idx]) << shift
        }
        return F(val)
    }
}

internal extension UInt8 {
    func byteCount() -> UInt8? {
        switch self {
        case let value where value < Constants.maxArgSize:
            0
        case 24:
            1
        case 25:
            2
        case 26:
            4
        case 27:
            8
        default:
            nil
        }
    }
}
