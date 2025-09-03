//
//  Data+ExpressibleByArrayLiteral.swift
//  CBOR
//
//  Created by Khan Winter on 8/24/25.
//

#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif
@testable import CBOR

extension Data: @retroactive ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = UInt8

    public init(arrayLiteral elements: UInt8...) {
        self.init(elements)
    }
}
