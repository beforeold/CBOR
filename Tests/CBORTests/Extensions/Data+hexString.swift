//
//  Data+hexString.swift
//  CBOR
//
//  Created by Khan Winter on 9/1/25.
//

#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

extension Data {
    private static let hexAlphabet = Array("0123456789abcdef".unicodeScalars)

    func hexString() -> String {
        // I'd rather use: map { String(format: "%02hhX", $0) }.joined()
        // but that doesn't compile on linux...
        String(reduce(into: "".unicodeScalars) { result, value in
            result.append(Self.hexAlphabet[Int(value / 0x10)])
            result.append(Self.hexAlphabet[Int(value % 0x10)])
        })
    }
}
