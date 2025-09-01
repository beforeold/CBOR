//
//  UInt8+byteCount.swift
//  CBOR
//
//  Created by Khan Winter on 9/1/25.
//

internal extension UInt8 {
    func byteCount() -> UInt8? {
        switch self {
        case let value where value < Constants.maxArgSize:
            0
        case 24:
            1
        case 25:
            2
        case 26:
            4
        case 27:
            8
        default:
            nil
        }
    }
}
