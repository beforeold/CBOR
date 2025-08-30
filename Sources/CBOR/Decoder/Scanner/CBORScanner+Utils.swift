//
//  CBORScanner+Utils.swift
//  CBOR
//
//  Created by Khan Winter on 8/30/25.
//

extension CBORScanner {
    func popByteCount() throws -> Int {
        let byteCount = reader.popArgument()
        return switch byteCount {
        case let value where value < Constants.maxArgSize: 0
        case 24: 1
        case 25: 2
        case 26: 4
        case 27: 8
        default:
            throw ScanError.invalidSize(byte: byteCount, offset: reader.index - 1)
        }
    }

    func peekIsIndeterminate() -> Bool {
        (reader.peekArgument() ?? 0) == 0b1_1111
    }
}
