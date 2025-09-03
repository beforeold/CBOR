//
//  EncodingContext.swift
//  CBOR
//
//  Created by Khan Winter on 8/20/25.
//

#if canImport(FoundationEssentials)
import FoundationEssentials
#else
import Foundation
#endif

struct DecodingContext {
    let options: DecodingOptions
    let results: CBORScanner.Results

    let path: CodingPath

    var codingPath: [CodingKey] { path.expanded }

    init(options: DecodingOptions, results: CBORScanner.Results) {
        self.options = options
        self.results = results
        self.path = .root
    }

    private init(options: DecodingOptions, results: CBORScanner.Results, path: CodingPath) {
        self.options = options
        self.results = results
        self.path = path
    }

    func appending<Key: CodingKey>(_ key: Key) -> DecodingContext {
        DecodingContext(options: options, results: results, path: .child(key: key, parent: path))
    }

    func error(_ description: String = "", error: Error? = nil) -> DecodingError.Context {
        .init(codingPath: path.expanded, debugDescription: description, underlyingError: error)
    }
}
