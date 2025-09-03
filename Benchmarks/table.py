import re

def to_ns(val, unit):
    v = int(val)
    return v if unit == "ns" else v * 1000

files = [
    ("comparison-decoding", "Decoding"),
    ("comparison-encoding", "Encoding")
]

for file in files:
    with open(file[0] + ".md", "r") as f:
        markdown = f.read()

    # Split into sections by headings
    sections = re.split(r"(?=^### )", markdown, flags=re.MULTILINE)

    benchmarks = []
    for section in sections:
        header_match = re.match(r"### (.*?) metrics", section)
        if not header_match:
            continue
        name = header_match.group(1).strip()

        # Grab the unit (ns / µs / us) from the table header
        unit_match = re.search(r"\((ns|μs|us)\)", section)
        if not unit_match:
            continue
        unit = unit_match.group(1)

        # Extract p50 columns from rows like: | swiftcbor | 123 | 456 | ...
        row_pattern = r"\|\s*{}\s*\|\s*([0-9]+)\s*\|\s*([0-9]+)"
        swift_match = re.search(row_pattern.format("swiftcbor"), section, re.IGNORECASE)
        current_match = re.search(row_pattern.format("Current_run"), section, re.IGNORECASE)

        if swift_match and current_match:
            swift_p50 = to_ns(swift_match.group(2), unit)
            current_p50 = to_ns(current_match.group(2), unit)
            ratio = current_p50 / swift_p50 if swift_p50 > 0 else float("inf")
            benchmarks.append((name, swift_p50, current_p50, ratio))

    print("### " + file[1])
    print("")
    print("| Benchmark | SwiftCBOR (ns, p50) | CBOR (ns, p50) | % Improvement |")
    print("|-----------|----------------|-----------|------------|")
    for bench in benchmarks:
        improvement = (bench[1] - bench[2]) / bench[1] * 100
        print(f"| {bench[0]} | {bench[1]:,} | {bench[2]:,} | **{improvement:.2f}%** |")
    print("")