//
//  EncodingOptions.swift
//  SwiftCBOR
//
//  Created by Khan Winter on 8/17/25.
//

/// Options that determine the behavior of ``CBOREncoder``.
public struct EncodingOptions {
    /// Force encoded maps to use string keys even when integer keys are available.
    public let forceStringKeys: Bool

    /// Methods for encoding dates.
    public enum DateStrategy {
        /// Encodes dates as `ISO8601` date strings under tag `0`.
        case string
        /// Encodes dates as an epoch date using a Float value. Loses precision at the benefit of half the size
        /// of a double.
        case float
        /// Encodes dates as an epoch date using a Double value.
        /// Highest precision.
        case double
    }

    /// Determine how to encode dates.
    public let dateEncodingStrategy: DateStrategy

    /// Codable can't tell us if we're encoding a Data or [UInt8] object. By default this library assumes that if it's
    /// encoding an unkeyed container or UInt8 objects it's a byte string. Toggle this to false to disable this.
    /// **This will slow down all Data encoding operations dramatically**.
    public let assumeUInt8IsByteString: Bool

    /// Initialize new encoding options.
    /// - Parameters:
    ///   - forceStringKeys: Force encoded maps to use string keys even when integer keys are available.
    ///   - useStringDates: See ``dateEncodingStrategy`` and ``DateStrategy``.
    ///   - assumeUInt8IsByteString: See ``assumeUInt8IsByteString``.
    public init(forceStringKeys: Bool, dateEncodingStrategy: DateStrategy, assumeUInt8IsByteString: Bool) {
        self.forceStringKeys = forceStringKeys
        self.dateEncodingStrategy = dateEncodingStrategy
        self.assumeUInt8IsByteString = assumeUInt8IsByteString
    }
}
