//
//  DecodingOptions.swift
//  CBOR
//
//  Created by Khan Winter on 8/23/25.
//

public struct DecodingOptions {
    public var rejectIndeterminateLengthData: Bool
    public var rejectIndeterminateLengthStrings: Bool
    public var rejectIndeterminateLengthArrays: Bool
    public var rejectIndeterminateLengthMaps: Bool

    public init(
        rejectIndeterminateLengthData: Bool = true,
        rejectIndeterminateLengthStrings: Bool = true,
        rejectIndeterminateLengthArrays: Bool = true,
        rejectIndeterminateLengthMaps: Bool = true
    ) {
        self.rejectIndeterminateLengthData = rejectIndeterminateLengthData
        self.rejectIndeterminateLengthStrings = rejectIndeterminateLengthStrings
        self.rejectIndeterminateLengthArrays = rejectIndeterminateLengthArrays
        self.rejectIndeterminateLengthMaps = rejectIndeterminateLengthMaps
    }
}
