//
//  File.swift
//  SwiftCBOR
//
//  Created by Khan Winter on 8/17/25.
//

struct UnkeyedCBOREncodingContainer<ParentStorage: TemporaryEncodingStorage>: UnkeyedEncodingContainer {
    private let storage: KeyBuffer
    private let context: EncodingContext

    var codingPath: [CodingKey] { context.codingPath }
    var count: Int { storage.count }

    init(parent: ParentStorage, context: EncodingContext) {
        self.storage = KeyBuffer(parent: parent)
        self.context = context
    }

    private func nextContext() -> EncodingContext {
        context.appending(UnkeyedCodingKey(intValue: count))
    }

    func encode<T: Encodable>(_ value: T) throws {
        try value.encode(
            to: SingleValueCBOREncodingContainer(parent: storage.forAppending(), context: nextContext())
        )
    }

    func encode(_ value: UInt8) throws {
        storage.data.append(value)
        if !context.options.assumeUInt8IsByteString {
            try value.encode(
                to: SingleValueCBOREncodingContainer(parent: storage.forAppending(), context: nextContext())
            )
        }
    }

    mutating func encodeNil() throws {
        storage.forAppending().register(NilOptimizer())
    }

    mutating func nestedContainer<NestedKey: CodingKey>(
        keyedBy keyType: NestedKey.Type
    ) -> KeyedEncodingContainer<NestedKey> {
        KeyedEncodingContainer(KeyedCBOREncodingContainer(parent: storage.forAppending(), context: nextContext()))
    }

    mutating func nestedUnkeyedContainer() -> any UnkeyedEncodingContainer {
        UnkeyedCBOREncodingContainer<KeyBuffer.Indexed>(
            parent: storage.forAppending(),
            context: nextContext()
        )
    }

    mutating func superEncoder() -> any Encoder {
        fatalError("Unimplemented")
    }
}

extension UnkeyedCBOREncodingContainer {
    private final class KeyBuffer {
        var count: Int { items.count }

        let parent: ParentStorage
        var items: [EncodingOptimizer] = []
        var data: [UInt8] = []

        init(parent: ParentStorage) {
            self.parent = parent
            self.items = []
        }

        func forAppending() -> Indexed {
            items.append(EmptyOptimizer())
            return Indexed(parent: Unmanaged.passUnretained(self), index: items.count - 1)
        }

        struct Indexed: TemporaryEncodingStorage {
            let parent: Unmanaged<KeyBuffer>
            let index: Int

            func register(_ optimizer: EncodingOptimizer) {
                parent.takeUnretainedValue().items[index] = optimizer
            }
        }

        deinit {
            // Swift doesn't give us a good way to detect a 'byte string'. So, we record both UInt8 values and
            // some optimizers. At this point, we can check if we're encoding either a collection of multiple
            // types (items.count > data.count), or a pure data collection (data.count == items.count).
            // This is terrible in terms of memory use, but lets us encode byte strings using the most optimal
            // encoding method.
            // CBOR also mandates that an empty collection is by default an array, so we check if this is empty.
            // Frankly, this blows and I wish Swift's Codable API was even a smidgen less fucked.

            if items.count <= data.count && !data.isEmpty {
                parent.register(ByteStringOptimizer(value: data))
            } else {
                parent.register(UnkeyedOptimizer(value: items))
            }
        }
    }

}
