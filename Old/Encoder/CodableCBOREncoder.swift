import Foundation

public class CodableCBOREncoder {
    public var useStringKeys: Bool = false
    public var dateStrategy: DateStrategy = .taggedAsEpochTimestamp
    public var forbidNonStringMapKeys: Bool = false
    public var orderKeys: Bool = false

    struct _Options {
        let useStringKeys: Bool
        let dateStrategy: DateStrategy
        let forbidNonStringMapKeys: Bool
        let orderKeys: Bool

        init(
            useStringKeys: Bool = false,
            dateStrategy: DateStrategy = .taggedAsEpochTimestamp,
            forbidNonStringMapKeys: Bool = false,
            orderKeys: Bool = false
        ) {
            self.useStringKeys = useStringKeys
            self.dateStrategy = dateStrategy
            self.forbidNonStringMapKeys = forbidNonStringMapKeys
            self.orderKeys = orderKeys
        }

        func toCBOROptions() -> CBOROptions {
            return CBOROptions(
                useStringKeys: self.useStringKeys,
                dateStrategy: self.dateStrategy,
                forbidNonStringMapKeys: self.forbidNonStringMapKeys
            )
        }
    }

    var options: _Options {
        get {
            _Options(
                useStringKeys: self.useStringKeys,
                dateStrategy: self.dateStrategy,
                forbidNonStringMapKeys: self.forbidNonStringMapKeys,
                orderKeys: self.orderKeys
            )
        }
        set {
            self.useStringKeys = newValue.useStringKeys
            self.dateStrategy = newValue.dateStrategy
            self.forbidNonStringMapKeys = newValue.forbidNonStringMapKeys
        }
    }

    public init() {}

    public func encode(_ value: Encodable) throws -> Data {
        let encoder = _CBOREncoder(options: self.options)
        if let dateVal = value as? Date {
            return Data(CBOR.encodeDate(dateVal, options: self.options.toCBOROptions()))
        } else if let dataVal = value as? Data {
            return Data(CBOR.encodeData(dataVal, options: self.options.toCBOROptions()))
        }
        if options.forbidNonStringMapKeys {
            if let dict = value as? Dictionary<AnyHashable, Any?> {
                guard let _ = dict as? Dictionary<String, Any?> else {
                    throw CBOREncoderError.nonStringKeyInMap
                }
            }
        }

        try value.encode(to: encoder)
        return try encoder.data()
    }
}

final class _CBOREncoder {
    var codingPath: [CodingKey] = []

    var userInfo: [CodingUserInfoKey : Any] = [:]

    fileprivate var container: CBOREncodingContainer? {
        willSet {
            precondition(self.container == nil)
        }
    }

    func data() throws -> Data {
        try container?.data() ?? Data()
    }

    let options: CodableCBOREncoder._Options

    init(options: CodableCBOREncoder._Options = CodableCBOREncoder._Options()) {
        self.options = options
    }
}

extension _CBOREncoder: Encoder {
    fileprivate func assertCanCreateContainer() {
        precondition(self.container == nil)
    }

    func container<Key: CodingKey>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> {
        assertCanCreateContainer()

        let container = KeyedContainer<Key>(codingPath: self.codingPath, userInfo: self.userInfo, options: self.options)
        self.container = container

        return KeyedEncodingContainer(container)
    }

    func unkeyedContainer() -> UnkeyedEncodingContainer {
        assertCanCreateContainer()

        let container = UnkeyedContainer(codingPath: self.codingPath, userInfo: self.userInfo, options: self.options)
        self.container = container

        return container
    }

    func singleValueContainer() -> SingleValueEncodingContainer {
        assertCanCreateContainer()

        let container = SingleValueContainer(codingPath: self.codingPath, userInfo: self.userInfo, options: self.options)
        self.container = container

        return container
    }
}

protocol CBOREncodingContainer: AnyObject {
    func data() throws -> Data
}
