//
//  DataReader.swift
//  CBOR
//
//  Created by Khan Winter on 8/20/25.
//

import Foundation

/// A mutable struct used by the `CBORScanner` to iteratively scan a CBOR blob.
/// Since this isn't passed by reference, this represents the *entire* blob instead of a single value
/// like `DataRegion`.
///
/// This results in some duplicated code. I'd love to remove it but it works for now I suppose.
struct DataReader {
    private let data: Slice<UnsafeRawBufferPointer>
    private(set) var index = 0

    @inline(__always)
    @usableFromInline var count: Int {
        data.count - index
    }

    @inline(__always)
    @usableFromInline var isEmpty: Bool {
        data.count == index
    }

    init(data: Slice<UnsafeRawBufferPointer>) {
        self.data = data
    }

    @inline(__always)
    func canRead(_ numBytes: Int) -> Bool {
        count >= numBytes
    }

    @inline(__always)
    func canRead(_ numBytes: UInt) -> Bool {
        count >= numBytes
    }

    @discardableResult
    mutating func pop() -> UInt8 {
        assert(!isEmpty)
        defer { index += 1 }
        return _peek()
    }

    mutating func popArgument() -> UInt8 {
        pop() & 0b0001_1111
    }

    @discardableResult
    mutating func pop(_ num: Int) -> PlainDataRegion {
        assert(index + num <= data.count)
        defer { index += num }
        return PlainDataRegion(data: data[index..<(index + num)])
    }

    @inline(__always)
    func _peek() -> UInt8 {
        data[_offset: index]
    }

    @inline(__always)
    func peek() -> UInt8? {
        guard !isEmpty else { return nil }
        return _peek()
    }

    @inline(__always)
    func peekType() -> MajorType? {
        guard let raw = peek() else { return nil }
        return MajorType(rawValue: raw)
    }

    func peekArgument() -> UInt8? {
        guard let raw = peek() else { return nil }
        return raw & 0b0001_1111
    }

    @inline(__always)
    func peekNil() -> Bool {
        // This shouldn't modify the data stack. We just peek here.
        peekType() == .simple && peekArgument() == 22
    }

    @inline(__always)
    mutating func readInt<F: FixedWidthInteger>(as: F.Type) throws -> F {
        guard canRead(F.byteCount) else {
            throw CBORScanner.ScanError.unexpectedEndOfData
        }
        var val = F.zero
        for idx in 0..<(F.byteCount) {
            let shift = (F.byteCount - idx - 1) * 8
            val |= F(pop()) << shift
        }
        return F(val)
    }

    /// Reads the next variable-sized integer off the data stack.
    @inlinable
    mutating func readNextInt<T: FixedWidthInteger>(as: T.Type) throws -> T {
        let byteCount = popArgument()
        return switch byteCount {
        case let value where value < Constants.maxArgSize:
            T(value)
        case 24:
            T(try readInt(as: UInt8.self))
        case 25:
            T(try readInt(as: UInt16.self))
        case 26:
            T(try readInt(as: UInt32.self))
        case 27:
            T(try readInt(as: UInt64.self))
        default:
            throw CBORScanner.ScanError.invalidSize(byte: byteCount, offset: index - 1)
        }
    }

    @inlinable
    func slice(_ range: Range<Int>) -> Slice<UnsafeRawBufferPointer> { data[range] }
}
