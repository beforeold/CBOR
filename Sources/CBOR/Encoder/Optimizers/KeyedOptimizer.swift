//
//  KeyedOptimizer.swift
//  SwiftCBOR
//
//  Created by Khan Winter on 8/17/25.
//

import HeapModule

@inlinable
func KeyedOptimizer(value: [String: EncodingOptimizer]) -> EncodingOptimizer {
    if value.count < Constants.maxArgSize {
        return SmallKeyedOptimizer(value: value, optimizer: { StringOptimizer(value: $0) })
    } else {
        return LargeKeyedOptimizer(value: value, optimizer: { StringOptimizer(value: $0) })
    }
}

@inlinable
func KeyedOptimizer(value: [Int: EncodingOptimizer]) -> EncodingOptimizer {
    if value.count < Constants.maxArgSize {
        return SmallKeyedOptimizer(value: value, optimizer: { IntOptimizer(value: $0) })
    } else {
        return LargeKeyedOptimizer(value: value, optimizer: { IntOptimizer(value: $0) })
    }
}

private struct KeyValue<KeyType: Comparable>: Comparable {
    let id: KeyType
    var key: EncodingOptimizer
    var value: EncodingOptimizer

    @usableFromInline var size: Int {
        key.size + value.size
    }

    static func < (lhs: KeyValue, rhs: KeyValue) -> Bool {
        lhs.id < rhs.id
    }

    static func == (lhs: KeyValue, rhs: KeyValue) -> Bool {
        lhs.id == rhs.id
    }
}

@usableFromInline
struct SmallKeyedOptimizer<KeyType: Comparable & Hashable>: EncodingOptimizer {
    fileprivate var value: Heap<KeyValue<KeyType>>

    @usableFromInline var type: MajorType { .map }
    @usableFromInline var argument: UInt8 { UInt8(value.count) }
    @usableFromInline var contentSize: Int

    @usableFromInline
    init(value: [KeyType: EncodingOptimizer], optimizer: (KeyType) -> EncodingOptimizer) {
        (self.value, contentSize) = _makeHeap(value: value, optimizer: optimizer)
    }

    @usableFromInline
    mutating func writePayload(to data: inout Slice<UnsafeMutableRawBufferPointer>) {
        _writePayload(heap: value, to: &data)
    }
}

@usableFromInline
struct LargeKeyedOptimizer<KeyType: Comparable & Hashable>: EncodingOptimizer {
    fileprivate var value: Heap<KeyValue<KeyType>>

    @usableFromInline var type: MajorType { .map }
    @usableFromInline var argument: UInt8 { countToArg(value.count) }
    @usableFromInline var headerSize: Int { countToHeaderSize(value.count) }
    @usableFromInline var contentSize: Int

    @usableFromInline
    init(value: [KeyType: EncodingOptimizer], optimizer: (KeyType) -> EncodingOptimizer) {
        (self.value, contentSize) = _makeHeap(value: value, optimizer: optimizer)
    }

    @usableFromInline
    func writeHeader(to data: inout Slice<UnsafeMutableRawBufferPointer>) {
        writeIntToHeader(value.count, data: &data)
    }

    @usableFromInline
    mutating func writePayload(to data: inout Slice<UnsafeMutableRawBufferPointer>) {
        _writePayload(heap: value, to: &data)
    }
}

@inline(__always)
private func _makeHeap<KeyType: Comparable & Hashable>(
    value: [KeyType: EncodingOptimizer],
    optimizer: (KeyType) -> EncodingOptimizer
) -> (Heap<KeyValue<KeyType>>, contentSize: Int) {
    var foundKeys: Set<KeyType> = []
    var heap = Heap<KeyValue<KeyType>>()
    var size = 0
    for (key, value) in value {
        guard !foundKeys.contains(key) else { continue }
        foundKeys.insert(key)
        let optimized = KeyValue(id: key, key: optimizer(key), value: value)
        heap.insert(optimized)
        size += optimized.size
    }
    return (heap, size)
}

@inline(__always)
private func _writePayload<KeyType: Comparable & Hashable>(
    heap: consuming Heap<KeyValue<KeyType>>,
    to data: inout Slice<UnsafeMutableRawBufferPointer>
) {
    while var keyValue = heap.popMin() {
        keyValue.key.write(to: &data)
        keyValue.value.write(to: &data)
    }
}
