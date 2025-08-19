//
//  Constants.swift
//  SwiftCBOR
//
//  Created by Khan Winter on 8/17/25.
//

@usableFromInline
enum Constants {
    // Values below this value can be encoded in the argument field.
    @inline(__always)
    @usableFromInline static let maxArgSize = 24
}
