//
//  UUIDOptimizer.swift
//  SwiftCBOR
//
//  Created by Khan Winter on 8/17/25.
//

#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

struct UUIDOptimizer: EncodingOptimizer {
    var optimizer: SmallByteStringOptimizer<[UInt8]>

    var type: MajorType { .tagged }
    var argument: UInt8 { 24 }
    var headerSize: Int { 1 }
    var contentSize: Int { optimizer.size }

    init(value: UUID) {
        optimizer = withUnsafeBytes(of: value) { ptr in
            SmallByteStringOptimizer(value: Array(ptr))
        }
    }

    mutating func writeHeader(to data: inout Slice<UnsafeMutableRawBufferPointer>) {
        data[data.startIndex] = UInt8(CommonTags.uuid.rawValue)
        data.removeFirst()
    }

    mutating func writePayload(to data: inout Slice<UnsafeMutableRawBufferPointer>) {
        optimizer.write(to: &data)
    }

}
