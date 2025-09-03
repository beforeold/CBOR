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

    /// Initialize new encoding options.
    /// - Parameters:
    ///   - forceStringKeys: Force encoded maps to use string keys even when integer keys are available.
    ///   - useStringDates: See ``dateEncodingStrategy`` and ``DateStrategy``.
    public init(forceStringKeys: Bool, dateEncodingStrategy: DateStrategy) {
        self.forceStringKeys = forceStringKeys
        self.dateEncodingStrategy = dateEncodingStrategy
    }
}
