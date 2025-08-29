import Foundation
import Benchmark
import CBOR
//import SwiftCBOR

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
    // MARK: - Int

    Benchmark("Int") { benchmark in
        let decoder = CBORDecoder()
        let data = Data([27, 1, 0, 0, 39, 10, 0, 2, 1])
        benchmark.startMeasurement()
        blackHole(try decoder.decode(Int.self, from: data))
    }

    Benchmark("Int Small") { benchmark in
        let decoder = CBORDecoder()
        let data = Data([0])
        benchmark.startMeasurement()
        blackHole(try decoder.decode(Int.self, from: data))
    }

    // MARK: - String

//    Benchmark("String") { benchmark in
//        let data = "6b68656c6c6f20776f726c64".asHexData()
//        let decoder = CBORDecoder()
//        benchmark.startMeasurement()
//        blackHole(try decoder.decode(String.self, from: data))
//    }
//
//    Benchmark("String Small") { benchmark in
//        let decoder = CBORDecoder()
//        let data = "60".asHexData()
//        benchmark.startMeasurement()
//        blackHole(try decoder.decode(String.self, from: data))
//    }
}
