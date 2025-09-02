//
//  Data+hexString.swift
//  CBOR
//
//  Created by Khan Winter on 9/1/25.
//

import Foundation

extension Data {
    func hexString() -> String {
        map { String(format: "%02hhX", $0) }.joined()
    }
}
