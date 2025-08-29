import Foundation

extension _CBOREncoder {
    final class UnkeyedContainer {
        private var storage: [CBOREncodingContainer] = []

        var count: Int {
            return storage.count
        }

        var codingPath: [CodingKey]

        var nestedCodingPath: [CodingKey] {
            return self.codingPath + [AnyCodingKey(intValue: self.count)]
        }

        var userInfo: [CodingUserInfoKey: Any]

        let options: CodableCBOREncoder._Options

        init(codingPath: [CodingKey], userInfo: [CodingUserInfoKey : Any], options: CodableCBOREncoder._Options) {
            self.codingPath = codingPath
            self.userInfo = userInfo
            self.options = options
        }
    }
}

extension _CBOREncoder.UnkeyedContainer: UnkeyedEncodingContainer {
    func encodeNil() throws {
        var container = self.nestedSingleValueContainer()
        try container.encodeNil()
    }

    func encode<T: Encodable>(_ value: T) throws {
        var container = self.nestedSingleValueContainer()
        try container.encode(value)
    }

    private func nestedSingleValueContainer() -> SingleValueEncodingContainer {
        let container = _CBOREncoder.SingleValueContainer(codingPath: self.nestedCodingPath, userInfo: self.userInfo, options: self.options)
        self.storage.append(container)

        return container
    }

    func nestedContainer<NestedKey: CodingKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> {
        let container = _CBOREncoder.KeyedContainer<NestedKey>(codingPath: self.nestedCodingPath, userInfo: self.userInfo, options: self.options)
        self.storage.append(container)

        return KeyedEncodingContainer(container)
    }

    func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        let container = _CBOREncoder.UnkeyedContainer(codingPath: self.nestedCodingPath, userInfo: self.userInfo, options: self.options)
        self.storage.append(container)

        return container
    }

    func superEncoder() -> Encoder {
        fatalError("Unimplemented") // FIXME
    }
}

extension _CBOREncoder.UnkeyedContainer: CBOREncodingContainer {
    func data() throws -> Data {
        var data = Data()
        if storage.count >= 31 {
            data.append(0b100_11111) // array tag + indefinite count
        } else {
            data.append(0b100_00000 | UInt8(storage.count)) // array tag + count
        }

        for container in storage {
            data.append(contentsOf: try container.data())
        }

        if storage.count >= 31 {
            data.append(0xFF) // 32, the BREAK code to end the indeterminate array length.
        }

        return Data(data)
    }
}
