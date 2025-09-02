//
//  ScanItem.swift
//  CBOR
//
//  Created by Khan Winter on 9/1/25.
//

extension CBORScanner {
    /// After the scanner scans, this contains a map that allows the CBOR data to be scanned for values at arbitrary
    /// positions, keys, etc. The map contents are represented literally as ints for performance but uses the
    /// following map:
    /// ```
    /// enum ScanItem: Int {
    ///     case map // (childCount: Int, mapCount: Int, offset: Int, byteCount: Int)
    ///     case array // (childCount: Int, mapCount: Int, offset: Int, byteCount: Int)
    ///
    ///     case int // (offset: Int, byteCount: Int)
    ///     case string
    ///     case byteString
    ///     case simple // (offset: Int)
    ///     case tagged
    /// }
    /// ```
    struct Results {
        private var map: [Int] = []
        private var reader: DataReader

        var isEmpty: Bool {
            map.isEmpty
        }

        func contents() -> [Int] {
            map
        }

        init(dataCount: Int, reader: DataReader) {
            self.map = []
//            map.reserveCapacity(dataCount * 4)
            self.reader = reader
        }

        mutating func recordMapStart(currentByteIndex: Int) -> Int {
            map.append(MajorType.map.intValue)
            map.append(0)
            map.append(map.count + 3)
            map.append(currentByteIndex)
            map.append(currentByteIndex)
            return map.count - 5
        }

        mutating func recordArrayStart(currentByteIndex: Int) -> Int {
            map.append(MajorType.array.intValue)
            map.append(0) // child count
            map.append(map.count + 3) // map count
            map.append(currentByteIndex) // start byte
            map.append(currentByteIndex) // byte count
            return map.count - 5
        }

        mutating func recordEnd(childCount: Int, resultLocation: Int, currentByteIndex: Int) {
            map[resultLocation + 1] = childCount
            map[resultLocation + 2] = map.count - map[resultLocation + 2]
            map[resultLocation + 4] = currentByteIndex - map[resultLocation + 4]
        }

        mutating func recordType(_ type: UInt8, currentByteIndex: Int, length: Int) {
            map.append(Int(type))
            map.append(currentByteIndex)
            map.append(length)
        }

        mutating func recordSimple(_ type: UInt8, currentByteIndex: Int) {
            map.append(Int(type))
            map.append(currentByteIndex)
        }

        // MARK: - Load Values

        func load(at mapIndex: Int) -> DataRegion {
            assert(mapIndex < map.count)
            let byte = UInt8(map[mapIndex])
            let argument = byte & 0b1_1111
            guard let type = MajorType(rawValue: byte) else {
                fatalError("Invalid type found in map: \(map[mapIndex]) at index: \(mapIndex)")
            }
            switch type {
            case .uint, .nint, .bytes, .string, .tagged:
                assert(mapIndex + 1 < map.count)
                let location = map[mapIndex + 1]
                let length = map[mapIndex + 2]
                let slice = reader.slice(location..<(location + length))
                return DataRegion(type: type, argument: argument, childCount: nil, mapOffset: mapIndex, data: slice)
            case .simple:
                let length = UInt8(map[mapIndex]).simpleLength()
                let slice: Slice<UnsafeRawBufferPointer>
                if length == 0 {
                    slice = reader.slice(0..<0)
                } else {
                    let location = map[mapIndex + 1] + 1 // skip type & arg byte.
                    slice = reader.slice(location..<(location + length))
                }
                return DataRegion(type: type, argument: argument, childCount: nil, mapOffset: mapIndex, data: slice)
            case .array, .map:
                // Map determines the slice size
                let childCount = map[mapIndex + 1]
                let location = map[mapIndex + 3]
                let length = map[mapIndex + 4]
                let slice = reader.slice(location..<(location + length))
                return DataRegion(
                    type: type,
                    argument: argument,
                    childCount: childCount,
                    mapOffset: mapIndex,
                    data: slice
                )
            }
        }

        // MARK: - Map Navigation

        func firstChildIndex(_ mapIndex: Int) -> Int {
            let byte = UInt8(map[mapIndex])
            guard let type = MajorType(rawValue: byte) else {
                fatalError("Invalid type found in map: \(map[mapIndex]) at index: \(mapIndex)")
            }
            switch type {
            case .uint, .nint, .bytes, .string, .tagged, .simple:
                fatalError("Can't find child index for non-container type.")
            case .array, .map: // type byte + 4 map values
                return mapIndex + 5
            }
        }

        func siblingIndex(_ mapIndex: Int) -> Int {
            let byte = UInt8(map[mapIndex])
            guard let type = MajorType(rawValue: byte) else {
                fatalError("Invalid type found in map: \(map[mapIndex]) at index: \(mapIndex)")
            }
            switch type {
            case .uint, .nint, .bytes, .string:
                return mapIndex + 3
            case .simple:
                return mapIndex + 2
            case .array, .map: // Map contains the map/array count
                return mapIndex + 5 + map[mapIndex + 2]
            case .tagged:
                // Find the next index after the scanned data for the tagged item.
                return siblingIndex(mapIndex + 3)
            }
        }

        func loadTagData(tagMapIndex mapIndex: Int) -> DataRegion {
            return load(at: mapIndex + 3)
        }
    }
}
