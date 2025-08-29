//
//  CBOREncoder.swift
//  SwiftCBOR
//
//  Created by Khan Winter on 8/17/25.
//

#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

/// Serializes ``Encodable`` objects using the CBOR serialization format.
///
/// To perform serialization, use the ``encode(_:)-6zhmp`` method to convert a Codable object to ``Data``. To
/// configure encoding behavior, either pass customization options in with
/// ``init(forceStringKeys:useStringDates:assumeUInt8IsByteString:)`` or modify ``options``.
public struct CBOREncoder {
    /// Options that determine the behavior of ``CBOREncoder``.
    public var options: EncodingOptions

    /// Create a new CBOR encoder.
    /// - Parameters:
    ///   - forceStringKeys: See ``EncodingOptions/forceStringKeys``.
    ///   - useStringDates: See ``EncodingOptions/useStringDates``.
    ///   - assumeUInt8IsByteString: See ``EncodingOptions/assumeUInt8IsByteString``.
    public init(forceStringKeys: Bool = false, useStringDates: Bool = false, assumeUInt8IsByteString: Bool = true) {
        options = EncodingOptions(
            forceStringKeys: forceStringKeys,
            useStringDates: useStringDates,
            assumeUInt8IsByteString: assumeUInt8IsByteString
        )
    }

    /// Returns a CBOR-encoded representation of the value you supply.
    /// - Parameter value: The value to encode as CBOR data.
    /// - Returns: The encoded CBOR data.
    public func encode<T: Encodable>(_ value: T) throws -> Data {
        let tempStorage = TopLevelTemporaryEncodingStorage()

        let encodingContext = EncodingContext(options: options)
        let encoder = SingleValueCBOREncodingContainer(parent: tempStorage, context: encodingContext)
        try value.encode(to: encoder)

        let dataSize = tempStorage.value.size
        var data = Data(count: dataSize)
        data.withUnsafeMutableBytes { ptr in
            var slice = ptr[...]
            tempStorage.value.write(to: &slice)
            assert(slice.isEmpty)
        }
        return data
    }

    /// Returns a CBOR-encoded representation of the value you supply.
    /// - Note: This method is identical to ``encode(_:)-6zhmp``. This is a fast path included due to the lack of
    ///         ability to specialize Codable containers for specific types, such as byte strings.
    /// - Parameter value: The value to encode as CBOR data.
    /// - Returns: The encoded CBOR data.
    public func encode(_ value: Data) throws -> Data {
        // Fast path for plain data objects. See comments in ``UnkekedCBOREncodingContainer`` for why this can't be done
        // via the real Codable APIs. Hate that we have to 'cheat' like this to get the performance I'd like for
        // byte strings. >:(

        var optimizer = ByteStringOptimizer(value: value)
        let dataSize = optimizer.size
        var data = Data(count: dataSize)
        data.withUnsafeMutableBytes { ptr in
            var slice = ptr[...]
            optimizer.write(to: &slice)
            assert(slice.isEmpty)
        }
        return data
    }
}
