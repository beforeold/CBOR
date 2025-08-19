//
//  IntOptimizer.swift
//  SwiftCBOR
//
//  Created by Khan Winter on 8/17/25.
//

@inlinable
func IntOptimizer<IntType: FixedWidthInteger>(value: IntType) -> EncodingOptimizer {
    if value < 0 {
        let encodingValue: UInt = UInt(-1 - value)
        if value > -Constants.maxArgSize {
            return SmallNegativeIntOptimizer(value: encodingValue)
        } else {
            if (0...UInt(UInt8.max)).contains(encodingValue) {
                return NegativeIntOptimizer(value: UInt8(encodingValue))
            }

            if (0...UInt(UInt16.max)).contains(encodingValue) {
                return NegativeIntOptimizer(value: UInt16(encodingValue))
            }

            if (0...UInt(UInt32.max)).contains(encodingValue) {
                return NegativeIntOptimizer(value: UInt32(encodingValue))
            }

            return NegativeIntOptimizer(value: encodingValue)
        }
    } else {
        if value < Constants.maxArgSize {
            return SmallPositiveIntOptimizer(value: value)
        } else {
            let encodingValue = UInt(value)
            if (0...UInt(UInt8.max)).contains(encodingValue) {
                return PositiveIntOptimizer(value: UInt8(encodingValue))
            }

            if (0...UInt(UInt16.max)).contains(encodingValue) {
                return PositiveIntOptimizer(value: UInt16(encodingValue))
            }

            if (0...UInt(UInt32.max)).contains(encodingValue) {
                return PositiveIntOptimizer(value: UInt32(encodingValue))
            }

            return PositiveIntOptimizer(value: encodingValue)
        }
    }
}

@usableFromInline
struct SmallPositiveIntOptimizer<IntType: FixedWidthInteger>: EncodingOptimizer {
    let value: UInt8

    @usableFromInline var type: MajorType { .uint }
    @usableFromInline var argument: UInt8 { value }
    @usableFromInline var contentSize: Int { 0 }

    @usableFromInline
    init(value: IntType) {
        assert(value < Constants.maxArgSize)
        assert(value >= IntType.zero)
        self.value = UInt8(truncatingIfNeeded: value)
    }

    @usableFromInline
    func writePayload(to data: inout Slice<UnsafeMutableRawBufferPointer>) { }
}

@usableFromInline
struct SmallNegativeIntOptimizer<IntType: FixedWidthInteger>: EncodingOptimizer {
    let value: UInt8

    @usableFromInline var type: MajorType { .nint }
    @usableFromInline var argument: UInt8 { UInt8(value) }
    @usableFromInline var contentSize: Int { 0 }

    @usableFromInline
    init(value: IntType) {
        assert(value > -Constants.maxArgSize)
        assert(value >= IntType.zero) // -1 is encoded as 0
        self.value = UInt8(truncatingIfNeeded: value) // Positive representation
    }

    @usableFromInline
    func writePayload(to data: inout Slice<UnsafeMutableRawBufferPointer>) { }
}

@usableFromInline
struct PositiveIntOptimizer<IntType: FixedWidthInteger>: EncodingOptimizer {
    let value: IntType

    @usableFromInline var type: MajorType { .uint }
    @usableFromInline var argument: UInt8 { IntType.argumentValue }
    @usableFromInline var contentSize: Int { IntType.byteCount }

    @usableFromInline
    init(value: IntType) {
        assert(value >= Constants.maxArgSize)
        assert(value >= IntType.zero)
        self.value = value
    }

    @usableFromInline
    func writePayload(to data: inout Slice<UnsafeMutableRawBufferPointer>) {
        value.write(to: &data)
    }
}

@usableFromInline
struct NegativeIntOptimizer<IntType: FixedWidthInteger>: EncodingOptimizer {
    let value: IntType

    @usableFromInline var type: MajorType { .nint }
    @usableFromInline var argument: UInt8 { IntType.argumentValue }
    @usableFromInline var contentSize: Int { IntType.byteCount }

    @usableFromInline
    init(value: IntType) {
        assert(value >= -Constants.maxArgSize)
        assert(value >= IntType.zero) // -1 is encoded as 0
        self.value = value // Positive representation
    }

    @usableFromInline
    func writePayload(to data: inout Slice<UnsafeMutableRawBufferPointer>) {
        value.write(to: &data)
    }
}
