//
//  SingleValueCBOREncodingContainer.swift
//  SwiftCBOR
//
//  Created by Khan Winter on 8/17/25.
//

#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

struct SingleValueCBOREncodingContainer<Storage: TemporaryEncodingStorage>: Encoder {
    let parent: Storage
    let context: EncodingContext

    var userInfo: [CodingUserInfoKey: Any] = [:]
    var options: EncodingOptions { context.options }
    var codingPath: [CodingKey] { context.codingPath }

    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
        .init(KeyedCBOREncodingContainer(parent: parent, context: context))
    }

    func unkeyedContainer() -> UnkeyedEncodingContainer {
        UnkeyedCBOREncodingContainer(parent: parent, context: context)
    }

    func singleValueContainer() -> SingleValueEncodingContainer {
        self
    }
}

extension SingleValueCBOREncodingContainer: SingleValueEncodingContainer {
    func encodeNil() throws {
        parent.register(NilOptimizer())
    }

    func encode(_ value: String) throws {
        parent.register(StringOptimizer(value: value))
    }

    func encode(_ value: Bool) throws {
        parent.register(BoolOptimizer(value: value))
    }

    func encode(_ value: Double) throws {
        parent.register(DoubleOptimizer(value: value))
    }

    func encode(_ value: Float) throws {
        parent.register(FloatOptimizer(value: value))
    }

    func encode<T>(_ value: T) throws where T: Encodable, T: FixedWidthInteger {
        parent.register(IntOptimizer(value: value))
    }

    func encode<T>(_ value: T) throws where T: Encodable {
        // I hate this conditional cast, but Swift forces us to do this because Codable can't implement a specialized
        // function for any type, only the standard library types. This is the same method Foundation uses to detect
        // special encoding cases. It's still lame.

        if let date = value as? Date {
            if options.useStringDates {
                parent.register(StringDateOptimizer(value: date))
            } else {
                parent.register(EpochDateOptimizer(value: date))
            }
        } else if let uuid = value as? UUID {
            parent.register(UUIDOptimizer(value: uuid))
        } else if let data = value as? Data {
            parent.register(ByteStringOptimizer(value: data))
        } else {
            try value.encode(to: self)
        }
    }
}
