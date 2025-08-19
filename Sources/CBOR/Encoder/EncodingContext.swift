//
//  EncodingContext.swift
//  SwiftCBOR
//
//  Created by Khan Winter on 8/17/25.
//

/// Encoding context, shared between all internal encoders, containers, etc. during encoding process.
struct EncodingContext {
    fileprivate class Shared {
        let options: EncodingOptions

        init(options: EncodingOptions) {
            self.options = options
        }
    }

    fileprivate let shared: Shared
    var path: CodingPath = .root

    var options: EncodingOptions { shared.options }
    var codingPath: [CodingKey] { path.expanded }

    init(options: EncodingOptions) {
        shared = Shared(options: options)
    }

    func appending<Key: CodingKey>(_ key: Key) -> EncodingContext {
        var temp = self
        temp.path = .child(key: key, parent: path)
        return temp
    }
}
