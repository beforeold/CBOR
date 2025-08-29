//
//  Data+ExpressibleByArrayLiteral.swift
//  CBOR
//
//  Created by Khan Winter on 8/24/25.
//

import Foundation
@testable import CBOR

extension Data: @retroactive ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = UInt8

    public init(arrayLiteral elements: UInt8...) {
        self.init(elements)
    }
}
