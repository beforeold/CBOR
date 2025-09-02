import Foundation
import Benchmark
import CBOR
//import SwiftCBOR

typealias DecoderObject = CBORDecoder

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

let benchmarks: @Sendable () -> Void =  {
    struct Person: Codable {
        let name: String
        let age: Int
        let email: String
        let isActive: Bool
        let tags: [String]
    }

    struct Company: Codable {
        let name: String
        let founded: Int
        let employees: [Person]
        let metadata: [String: String]
    }

    // MARK: - Int

    Benchmark("Int") { benchmark in
        let decoder = DecoderObject()
        let data = Data([27, 1, 0, 0, 39, 10, 0, 2, 1])
        benchmark.startMeasurement()
        blackHole(try decoder.decode(Int.self, from: data))
    }

    Benchmark("Int Small") { benchmark in
        let decoder = DecoderObject()
        let data = Data([0])
        benchmark.startMeasurement()
        blackHole(try decoder.decode(Int.self, from: data))
    }

    // MARK: - String

    Benchmark("String") { benchmark in
        let data = "6b68656c6c6f20776f726c64".asHexData()
        let decoder = DecoderObject()
        benchmark.startMeasurement()
        blackHole(try decoder.decode(String.self, from: data))
    }

    Benchmark("String Small") { benchmark in
        let decoder = DecoderObject()
        let data = "60".asHexData()
        benchmark.startMeasurement()
        blackHole(try decoder.decode(String.self, from: data))
    }

    // MARK: - Float

    Benchmark("Float") { benchmark in
        let data = "fa47c35000".asHexData()
        let decoder = DecoderObject()
        benchmark.startMeasurement()
        blackHole(try decoder.decode(Float.self, from: data))
    }

    // MARK: - Double

    Benchmark("Double") { benchmark in
        let data = "FB3FB9B089A0275254".asHexData()
        let decoder = DecoderObject()
        benchmark.startMeasurement()
        blackHole(try decoder.decode(Double.self, from: data))
    }

    // MARK: - Indeterminate String

    Benchmark("Indeterminate String") { benchmark in
        let data = "7F61416142FF".asHexData()
        let decoder = DecoderObject(rejectIndeterminateLengths: false)
        benchmark.startMeasurement()
        blackHole(try decoder.decode(String.self, from: data))
    }

    // MARK: - Dictionary

    Benchmark("Dictionary") { benchmark in
        let data = "A262414201614102".asHexData()
        let decoder = DecoderObject()
        benchmark.startMeasurement()
        blackHole(try decoder.decode([String: Int].self, from: data))
    }

    // MARK: - Array

    Benchmark("Array") { benchmark in
        let data = "940101010101010101010101010101010101010101".asHexData()
        let decoder = DecoderObject()
        benchmark.startMeasurement()
        blackHole(try decoder.decode([Int].self, from: data))
    }

    // MARK: - Date

    Benchmark("Date") { benchmark in
        let data = "C11A5C295C00".asHexData()
        let decoder = DecoderObject()
        benchmark.startMeasurement()
        blackHole(try decoder.decode(Date.self, from: data))
    }

    // MARK: - Simple Object

    Benchmark("Simple Object") { benchmark in
        let data = "A563616765181E65656D61696C71616C696365406578616D706C652E636F6D686973416374697665F5646E616D6565416C6963656474616773836573776966746463626F726962656E63686D61726B".asHexData()
        let decoder = DecoderObject()
        benchmark.startMeasurement()
        blackHole(try decoder.decode(Person.self, from: data))
    }

    // MARK: - Complex Object

    Benchmark("Complex Object") { benchmark in
        let data = "A469656D706C6F796565738AA563616765181E65656D61696C71616C696365406578616D706C652E636F6D686973416374697665F5646E616D6565416C6963656474616773836573776966746463626F726962656E63686D61726BA563616765181E65656D61696C71616C696365406578616D706C652E636F6D686973416374697665F5646E616D6565416C6963656474616773836573776966746463626F726962656E63686D61726BA563616765181E65656D61696C71616C696365406578616D706C652E636F6D686973416374697665F5646E616D6565416C6963656474616773836573776966746463626F726962656E63686D61726BA563616765181E65656D61696C71616C696365406578616D706C652E636F6D686973416374697665F5646E616D6565416C6963656474616773836573776966746463626F726962656E63686D61726BA563616765181E65656D61696C71616C696365406578616D706C652E636F6D686973416374697665F5646E616D6565416C6963656474616773836573776966746463626F726962656E63686D61726BA563616765181E65656D61696C71616C696365406578616D706C652E636F6D686973416374697665F5646E616D6565416C6963656474616773836573776966746463626F726962656E63686D61726BA563616765181E65656D61696C71616C696365406578616D706C652E636F6D686973416374697665F5646E616D6565416C6963656474616773836573776966746463626F726962656E63686D61726BA563616765181E65656D61696C71616C696365406578616D706C652E636F6D686973416374697665F5646E616D6565416C6963656474616773836573776966746463626F726962656E63686D61726BA563616765181E65656D61696C71616C696365406578616D706C652E636F6D686973416374697665F5646E616D6565416C6963656474616773836573776966746463626F726962656E63686D61726BA563616765181E65656D61696C71616C696365406578616D706C652E636F6D686973416374697665F5646E616D6565416C6963656474616773836573776966746463626F726962656E63686D61726B67666F756E6465641907CF686D65746164617461A268696E6475737472796474656368686C6F636174696F6E6672656D6F7465646E616D656941636D6520436F7270".asHexData()
        let decoder = DecoderObject()
        benchmark.startMeasurement()
        blackHole(try decoder.decode(Company.self, from: data))
    }
}
