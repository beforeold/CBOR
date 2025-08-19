//
//  TemporaryEncodingStorage.swift
//  SwiftCBOR
//
//  Created by Khan Winter on 8/17/25.
//

/// Temporary Storage. Use while in the process of encoding data.
protocol TemporaryEncodingStorage {
    func register(_: EncodingOptimizer)
}

class TopLevelTemporaryEncodingStorage: TemporaryEncodingStorage {
    var value: EncodingOptimizer = EmptyOptimizer()

    func register(_ newValue: EncodingOptimizer) {
        value = newValue
    }
}
