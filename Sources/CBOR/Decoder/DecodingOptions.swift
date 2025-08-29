//
//  DecodingOptions.swift
//  CBOR
//
//  Created by Khan Winter on 8/23/25.
//

/// Options that determine the behavior of ``CBORDecoder``.
public struct DecodingOptions {
    /// Set to `false` to allow indeterminate length objects to be decoded.
    /// `true` by default.
    ///
    /// For deterministic encoding, this **must** be enabled.
    public var rejectIndeterminateLengths: Bool

    /// Create a new options object.
    public init(rejectIndeterminateLengths: Bool = true) {
        self.rejectIndeterminateLengths = rejectIndeterminateLengths
    }
}
