import Foundation
import SwiftCBOR
import CBOR

@inline(never)
func blackhole<T>(_ value: T) { }

// Representative structs
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

func measure(iterations: Int, block: () throws -> Void) throws -> (total: Double, avg: Double) {
    var info = mach_timebase_info()
    guard mach_timebase_info(&info) == KERN_SUCCESS else { fatalError() }
    let start = mach_absolute_time()
    for _ in 0..<iterations {
        try block()
    }
    let end = mach_absolute_time()
    let elapsed = end - start
    let nanos = elapsed * UInt64(info.numer) / UInt64(info.denom)
    let msec = TimeInterval(nanos) / TimeInterval(NSEC_PER_MSEC)
    let avg = msec / Double(iterations)
    return (msec, avg)
}

@main
struct Benchmarks {
    // --- main logic ---
    static func main() throws {
        let person = Person(name: "Alice", age: 30, email: "alice@example.com", isActive: true, tags: ["swift", "cbor", "benchmark"])
        let company = Company(
            name: "Acme Corp",
            founded: 1999,
            employees: Array(repeating: person, count: 100),
            metadata: ["industry": "tech", "location": "remote"]
        )
        let string = String(repeating: "a", count: 1000)
        let stringSmall = "abc"
        let data = Data(repeating: 0x42, count: 1024)
        let dataSmall = Data([0x01, 0x02, 0x03])
        let dict = ["key": "value", "foo": "bar", "baz": "qux"]
        let dictSmall = ["a": "b"]
        let array = Array(0..<1000)
        let arraySmall = [1, 2, 3]
        let intVal = 123456789
        let intValSmall = 42
        let boolVal = true

        let swiftCBOR = CodableCBOREncoder()
        let cbor = CBOREncoder()
        let iterations = 1000
        print("--- Codable Encoding Benchmarks (\(iterations) iterations each) ---\n")

        let allBenchmarks: [Benchmark] = [
            PersonBenchmark(person: person),
            CompanyBenchmark(company: company),
            StringBenchmark(string: string),
            StringBenchmark(string: stringSmall, name: "String Small"),
            DataBenchmark(data: data),
            DataBenchmark(data: dataSmall, name: "Data Small"),
            DictionaryBenchmark(dict: dict),
            DictionaryBenchmark(dict: dictSmall, name: "Dictionary Small"),
            ArrayBenchmark(array: array),
            ArrayBenchmark(array: arraySmall, name: "Array Small"),
            IntBenchmark(intVal: intVal),
            IntBenchmark(intVal: intValSmall, name: "Int Small"),
            BoolBenchmark(boolVal: boolVal)
        ]

        let args = CommandLine.arguments
        var only: String? = nil
        if let onlyIdx = args.firstIndex(of: "--only"), onlyIdx + 1 < args.count {
            only = args[onlyIdx + 1].lowercased()
        }

        let benchmarksToRun: [Benchmark]
        if let only = only {
            benchmarksToRun = allBenchmarks.filter { $0.name.lowercased() == only }
            if benchmarksToRun.isEmpty {
                print("No benchmark found for --only \(only)")
                return
            }
        } else {
            benchmarksToRun = allBenchmarks
        }

        for bench in benchmarksToRun {
            try bench.run(swiftCBOR: swiftCBOR, cbor: cbor, iterations: iterations)
        }
    }
}

func printComparison(type: String, swiftCBOR: (Double, Double), cbor: (Double, Double)) {
    let absChange = cbor.1 - swiftCBOR.1
    let percentChange = swiftCBOR.1 == 0 ? 0 : (absChange / swiftCBOR.1) * 100
    print("Encoding: \(type)")
    print(String(format: "  SwiftCBOR: total=%.3fms, avg=%.6fms", swiftCBOR.0, swiftCBOR.1))
    print(String(format: "  CBOR:      total=%.3fms, avg=%.6fms", cbor.0, cbor.1))
    print(String(format: "  Δ avg: %.6fms (%+.2f%%)", absChange, percentChange))
    print("")
}


protocol Benchmark {
    var name: String { get }
    func run(swiftCBOR: CodableCBOREncoder, cbor: CBOREncoder, iterations: Int) throws
}

struct PersonBenchmark: Benchmark {
    let name: String
    let person: Person
    init(person: Person, name: String = "Person") { self.person = person; self.name = name }
    func run(swiftCBOR: CodableCBOREncoder, cbor: CBOREncoder, iterations: Int) throws {
        let swiftCBORResult = try measure(iterations: iterations) {
            let encoded = try swiftCBOR.encode(person)
            blackhole(encoded)
        }
        let cborResult = try measure(iterations: iterations) {
            let encoded = try cbor.encode(person)
            blackhole(encoded)
        }
        printComparison(type: name, swiftCBOR: swiftCBORResult, cbor: cborResult)
    }
}

struct CompanyBenchmark: Benchmark {
    let name: String
    let company: Company
    init(company: Company, name: String = "Company") { self.company = company; self.name = name }
    func run(swiftCBOR: CodableCBOREncoder, cbor: CBOREncoder, iterations: Int) throws {
        let swiftCBORResult = try measure(iterations: iterations) {
            let encoded = try swiftCBOR.encode(company)
            blackhole(encoded)
        }
        let cborResult = try measure(iterations: iterations) {
            let encoded = try cbor.encode(company)
            blackhole(encoded)
        }
        printComparison(type: name, swiftCBOR: swiftCBORResult, cbor: cborResult)
    }
}

struct StringBenchmark: Benchmark {
    let name: String
    let string: String
    init(string: String, name: String = "String") { self.string = string; self.name = name }
    func run(swiftCBOR: CodableCBOREncoder, cbor: CBOREncoder, iterations: Int) throws {
        let swiftCBORResult = try measure(iterations: iterations) {
            let encoded = try swiftCBOR.encode(string)
            blackhole(encoded)
        }
        let cborResult = try measure(iterations: iterations) {
            let encoded = try cbor.encode(string)
            blackhole(encoded)
        }
        printComparison(type: name, swiftCBOR: swiftCBORResult, cbor: cborResult)
    }
}

struct DataBenchmark: Benchmark {
    let name: String
    let data: Data
    init(data: Data, name: String = "Data") { self.data = data; self.name = name }
    func run(swiftCBOR: CodableCBOREncoder, cbor: CBOREncoder, iterations: Int) throws {
        let swiftCBORResult = try measure(iterations: iterations) {
            let encoded = try swiftCBOR.encode(data)
            blackhole(encoded)
        }
        let cborResult = try measure(iterations: iterations) {
            let encoded = try cbor.encode(data)
            blackhole(encoded)
        }
        printComparison(type: name, swiftCBOR: swiftCBORResult, cbor: cborResult)
    }
}

struct DictionaryBenchmark: Benchmark {
    let name: String
    let dict: [String: String]
    init(dict: [String: String], name: String = "Dictionary") { self.dict = dict; self.name = name }
    func run(swiftCBOR: CodableCBOREncoder, cbor: CBOREncoder, iterations: Int) throws {
        let swiftCBORResult = try measure(iterations: iterations) {
            let encoded = try swiftCBOR.encode(dict)
            blackhole(encoded)
        }
        let cborResult = try measure(iterations: iterations) {
            let encoded = try cbor.encode(dict)
            blackhole(encoded)
        }
        printComparison(type: name, swiftCBOR: swiftCBORResult, cbor: cborResult)
    }
}

struct ArrayBenchmark: Benchmark {
    let name: String
    let array: [Int]
    init(array: [Int], name: String = "Array") { self.array = array; self.name = name }
    func run(swiftCBOR: CodableCBOREncoder, cbor: CBOREncoder, iterations: Int) throws {
        let swiftCBORResult = try measure(iterations: iterations) {
            let encoded = try swiftCBOR.encode(array)
            blackhole(encoded)
        }
        let cborResult = try measure(iterations: iterations) {
            let encoded = try cbor.encode(array)
            blackhole(encoded)
        }
        printComparison(type: name, swiftCBOR: swiftCBORResult, cbor: cborResult)
    }
}

struct IntBenchmark: Benchmark {
    let name: String
    let intVal: Int
    init(intVal: Int, name: String = "Int") { self.intVal = intVal; self.name = name }
    func run(swiftCBOR: CodableCBOREncoder, cbor: CBOREncoder, iterations: Int) throws {
        let swiftCBORResult = try measure(iterations: iterations) {
            let encoded = try swiftCBOR.encode(intVal)
            blackhole(encoded)
        }
        let cborResult = try measure(iterations: iterations) {
            let encoded = try cbor.encode(intVal)
            blackhole(encoded)
        }
        printComparison(type: name, swiftCBOR: swiftCBORResult, cbor: cborResult)
    }
}

struct BoolBenchmark: Benchmark {
    let name: String
    let boolVal: Bool
    init(boolVal: Bool, name: String = "Bool") { self.boolVal = boolVal; self.name = name }
    func run(swiftCBOR: CodableCBOREncoder, cbor: CBOREncoder, iterations: Int) throws {
        let swiftCBORResult = try measure(iterations: iterations) {
            let encoded = try swiftCBOR.encode(boolVal)
            blackhole(encoded)
        }
        let cborResult = try measure(iterations: iterations) {
            let encoded = try cbor.encode(boolVal)
            blackhole(encoded)
        }
        printComparison(type: name, swiftCBOR: swiftCBORResult, cbor: cborResult)
    }
}
