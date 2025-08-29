import Foundation
import HeapModule

extension _CBOREncoder {
    final class KeyedContainer<Key: CodingKey> {
        struct StorageItem: Comparable {
            let key: AnyCodingKey
            let value: CBOREncodingContainer

            static func < (lhs: StorageItem, rhs: StorageItem) -> Bool {
                lhs.key.stringValue < rhs.key.stringValue
            }

            static func == (lhs: StorageItem, rhs: StorageItem) -> Bool {
                lhs.key.stringValue == rhs.key.stringValue
            }
        }

        var storage: Heap<StorageItem> = []

        var codingPath: [CodingKey]
        var userInfo: [CodingUserInfoKey: Any]

        let options: CodableCBOREncoder._Options

        init(codingPath: [CodingKey], userInfo: [CodingUserInfoKey : Any], options: CodableCBOREncoder._Options) {
            self.codingPath = codingPath
            self.userInfo = userInfo
            self.options = options
        }
    }
}

extension _CBOREncoder.KeyedContainer: KeyedEncodingContainerProtocol {
    func encodeNil(forKey key: Key) throws {
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encodeNil()
    }

    func encode<T: Encodable>(_ value: T, forKey key: Key) throws {
        var container = self.nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }

    private func nestedCodingPath(forKey key: CodingKey) -> [CodingKey] {
        return self.codingPath + [key]
    }

    private func nestedSingleValueContainer(forKey key: Key) -> SingleValueEncodingContainer {
        let container = _CBOREncoder.SingleValueContainer(
            codingPath: self.nestedCodingPath(forKey: key),
            userInfo: self.userInfo,
            options: self.options
        )
        self.storage.insert(storageItem(forKey: key, container: container))
        return container
    }

    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        let container = _CBOREncoder.UnkeyedContainer(
            codingPath: self.nestedCodingPath(forKey: key),
            userInfo: self.userInfo,
            options: self.options
        )
        self.storage.insert(storageItem(forKey: key, container: container))
        return container
    }

    func nestedContainer<NestedKey: CodingKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> {
        let container = _CBOREncoder.KeyedContainer<NestedKey>(
            codingPath: self.nestedCodingPath(forKey: key),
            userInfo: self.userInfo,
            options: self.options
        )
        self.storage.insert(storageItem(forKey: key, container: container))
        return KeyedEncodingContainer(container)
    }

    fileprivate func storageItem(forKey key: Key, container: CBOREncodingContainer) -> StorageItem {
        StorageItem(
            key: AnyCodingKey(key, useStringKey: self.options.useStringKeys),
            value: container
        )
    }

    func superEncoder() -> Encoder {
        fatalError("Unimplemented") // FIXME
    }

    func superEncoder(forKey key: Key) -> Encoder {
        fatalError("Unimplemented") // FIXME
    }
}

extension _CBOREncoder.KeyedContainer: CBOREncodingContainer {
    func data() throws -> Data {
        var data = Data()
        data.append(0b101_00000) // Blank count for now
        var foundKeys: Set<String> = []

        while let item = storage.popMin() {
            let key = item.key
            let container = item.value

            guard !foundKeys.contains(key.stringValue) else { continue }
            foundKeys.insert(key.stringValue)

            let keyContainer = _CBOREncoder.SingleValueContainer(codingPath: self.codingPath, userInfo: self.userInfo, options: self.options)
            try keyContainer.encode(key)
            data.append(contentsOf: try keyContainer.data())
            data.append(contentsOf: try container.data())

        }

        if foundKeys.count >= 31 {
            data[0] = data[0] | UInt8(0b11111) // >= 31 keys means we've broken the maximum size
            data.append(0xFF) // 32, the BREAK code to end the indeterminate mep length.
        } else {
            data[0] = data[0] | UInt8(foundKeys.count)
        }

        return Data(data)
    }
}
