//
//  CBORScanner+DebugDescription.swift
//  CBOR
//
//  Created by Khan Winter on 8/30/25.
//

#if DEBUG
extension CBORScanner: CustomDebugStringConvertible {
    @usableFromInline var debugDescription: String {
        var string = ""
        func indent(_ other: String, d: Int) { string += String(repeating: " ", count: d * 2) + other + "\n" }

        func gen(_ idx: Int, depth: Int) {
            let value = results.load(at: idx, reader: reader)
            switch value.type {
            case .map, .array:
                indent(
                    "\(value.type), mapIdx: \(value.mapOffset), children: \(value.childCount!), bytes: \(value.count)",
                    d: depth
                )
                var idx = results.firstChildIndex(idx)
                for _ in 0..<value.childCount! {
                    gen(idx, depth: depth + 1)
                    idx = results.siblingIndex(idx)
                }
            default:
                indent("\(value.type), mapIdx: \(value.mapOffset), arg: \(value.argument)", d: depth)
            }
        }

        gen(0, depth: 0)
        return string
    }
}
#endif
