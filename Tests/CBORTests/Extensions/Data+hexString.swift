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
    func hexString() -> String {
        map { String(format: "%02hhX", $0) }.joined()
    }
}
