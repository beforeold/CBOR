//
//  RoundTripTests.swift
//  CBOR
//
//  Created by Khan Winter on 8/28/25.
//

import Testing
import Foundation
@testable import CBOR

@Suite
struct RoundTripTests {
    @Test
    func int() throws {
        for _ in 0..<10 {
            let value = Int.random(in: 0..<Int.max)
            let data = try CBOREncoder().encode(value)
            let result = try CBORDecoder().decode(Int.self, from: data)
            #expect(value == result)
        }
    }

    @Test
    func bool() throws {
        var value = true
        var data = try CBOREncoder().encode(value)
        var result = try CBORDecoder().decode(Bool.self, from: data)
        #expect(value == result)

        value = false
        data = try CBOREncoder().encode(value)
        result = try CBORDecoder().decode(Bool.self, from: data)
        #expect(value == result)
    }

    @Test
    func float() throws {
        for _ in 0..<10 {
            let value = Float.random(in: -1000..<1000)
            let data = try CBOREncoder().encode(value)
            let result = try CBORDecoder().decode(Float.self, from: data)
            #expect(value == result)
        }
    }

    @Test
    func double() throws {
        for _ in 0..<10 {
            let value = Double.random(in: -1000..<1000)
            let data = try CBOREncoder().encode(value)
            let result = try CBORDecoder().decode(Double.self, from: data)
            #expect(value == result)
        }
    }
}
