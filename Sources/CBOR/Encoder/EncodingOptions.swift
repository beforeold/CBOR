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

    /// Encode dates as strings instead of epoch timestamps (Doubles)
    public let useStringDates: Bool

    /// Codable can't tell us if we're encoding a Data or [UInt8] object. By default this library assumes that if it's
    /// encoding an unkeyed container or UInt8 objects it's a byte string. Toggle this to false to disable this.
    /// **This will slow down all Data encoding operations dramatically**.
    public let assumeUInt8IsByteString: Bool

    /// Initialize new encoding options.
    /// - Parameters:
    ///   - forceStringKeys: Force encoded maps to use string keys even when integer keys are available.
    ///   - useStringDates: Encode dates as strings instead of epoch timestamps (Doubles)
    ///   - assumeUInt8IsByteString: See ``assumeUInt8IsByteString``.
    public init(forceStringKeys: Bool, useStringDates: Bool, assumeUInt8IsByteString: Bool) {
        self.forceStringKeys = forceStringKeys
        self.useStringDates = useStringDates
        self.assumeUInt8IsByteString = assumeUInt8IsByteString
    }
}
