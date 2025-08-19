//
//  MajorType.swift
//  SwiftCBOR
//
//  Created by Khan Winter on 8/17/25.
//

@usableFromInline
enum MajorType: UInt8 {
    case uint = 0
    case nint = 1
    case bytes = 2
    case string = 3
    case array = 4
    case map = 5
    case tagged = 6
    case simple = 7

    @inlinable
    init?(rawValue: UInt8) {
        // We only care about the top 3 bits
        switch rawValue >> 5 {
        case MajorType.uint.rawValue: self = .uint
        case MajorType.nint.rawValue: self = .nint
        case MajorType.bytes.rawValue: self = .bytes
        case MajorType.string.rawValue: self = .string
        case MajorType.array.rawValue: self = .array
        case MajorType.map.rawValue: self = .map
        case MajorType.tagged.rawValue: self = .tagged
        case MajorType.simple.rawValue: self = .simple
        default: return nil
        }
    }

    @inline(__always)
    @inlinable var bits: UInt8 {
        rawValue << 5
    }
}
