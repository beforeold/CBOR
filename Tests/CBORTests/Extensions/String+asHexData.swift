//
//  String+asHexData.swift
//  CBOR
//
//  Created by Khan Winter on 9/1/25.
//

#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

extension String {
    func asHexData() -> Data {
        guard self.count.isMultiple(of: 2) else {
            fatalError()
        }

        let chars = self.map { $0 }
        let bytes = stride(from: 0, to: chars.count, by: 2)
            .map { String(chars[$0]) + String(chars[$0 + 1]) }
            .compactMap { UInt8($0, radix: 16) }

        guard self.count / bytes.count == 2 else { fatalError() }
        return Data(bytes)
    }
}
