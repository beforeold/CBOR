//
//  EncodingContext.swift
//  CBOR
//
//  Created by Khan Winter on 8/20/25.
//

import Foundation

struct DecodingContext {
    private let _scanner: Unmanaged<CBORScanner>

    @inline(__always)
    @usableFromInline var scanner: CBORScanner {
        _scanner.takeUnretainedValue()
    }
    var path: CodingPath = .root

    var options: DecodingOptions { scanner.options }
    var codingPath: [CodingKey] { path.expanded }

    init(scanner: CBORScanner) {
        self._scanner = Unmanaged.passUnretained(scanner)
    }

    func appending<Key: CodingKey>(_ key: Key) -> DecodingContext {
        var temp = self
        temp.path = .child(key: key, parent: path)
        return temp
    }

    func error(_ description: String = "", error: Error? = nil) -> DecodingError.Context {
        .init(codingPath: path.expanded, debugDescription: description, underlyingError: error)
    }
}
