
## Comparing results between 'swiftcbor' and 'Current_run'

```
Host 'Khans-MacBook-Pro.local' with 10 'arm64' processors with 16 GB memory, running:
Darwin Kernel Version 24.3.0: Thu Jan  2 20:24:16 PST 2025; root:xnu-11215.81.4~3/RELEASE_ARM64_T6000
```

## Encoding

### Array metrics

<details><summary>Time (total CPU): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (total CPU) (μs) *          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |       665 |       666 |       669 |       675 |       682 |       715 |       758 |      1383 |
|               Current_run                |       470 |       471 |       471 |       474 |       481 |       501 |       535 |      2093 |
|                    Δ                     |      -195 |      -195 |      -198 |      -201 |      -201 |      -214 |      -223 |       710 |
|              Improvement %               |        29 |        29 |        30 |        30 |        29 |        30 |        29 |       710 |

<p>
</details>

### Array Small metrics

<details><summary>Time (total CPU): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (total CPU) (ns) *          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |      6874 |      7003 |      7043 |      7083 |      7167 |      7879 |     23417 |     10000 |
|               Current_run                |      2749 |      2875 |      2917 |      2959 |      2959 |      3125 |     22791 |     10000 |
|                    Δ                     |     -4125 |     -4128 |     -4126 |     -4124 |     -4208 |     -4754 |      -626 |         0 |
|              Improvement %               |        60 |        59 |        59 |        58 |        59 |        60 |         3 |         0 |

<p>
</details>

### Bool metrics

<details><summary>Time (total CPU): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (total CPU) (ns) *          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |      3041 |      3167 |      3169 |      3209 |      3251 |      3583 |     18209 |     10000 |
|               Current_run                |      1041 |      1124 |      1125 |      1126 |      1167 |      1292 |      8333 |     10000 |
|                    Δ                     |     -2000 |     -2043 |     -2044 |     -2083 |     -2084 |     -2291 |     -9876 |         0 |
|              Improvement %               |        66 |        65 |        64 |        65 |        64 |        64 |        54 |         0 |

<p>
</details>

### Complex Codable Object metrics

<details><summary>Time (total CPU): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (total CPU) (μs) *          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |       123 |       124 |       124 |       124 |       127 |       140 |       166 |      5760 |
|               Current_run                |        91 |        92 |        92 |        92 |        94 |        99 |       122 |     10000 |
|                    Δ                     |       -32 |       -32 |       -32 |       -32 |       -33 |       -41 |       -44 |      4240 |
|              Improvement %               |        26 |        26 |        26 |        26 |        26 |        29 |        27 |      4240 |

<p>
</details>

### Data metrics

<details><summary>Time (total CPU): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (total CPU) (ns) *          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |      5168 |      5295 |      5335 |      5375 |      5459 |      6003 |     19667 |     10000 |
|               Current_run                |      1125 |      1208 |      1250 |      1250 |      1292 |      1417 |      5584 |     10000 |
|                    Δ                     |     -4043 |     -4087 |     -4085 |     -4125 |     -4167 |     -4586 |    -14083 |         0 |
|              Improvement %               |        78 |        77 |        77 |        77 |        76 |        76 |        72 |         0 |

<p>
</details>

### Data Small metrics

<details><summary>Time (total CPU): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (total CPU) (ns) *          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |      3833 |      3917 |      3959 |      3959 |      4001 |      4375 |     21958 |     10000 |
|               Current_run                |       916 |       959 |      1000 |      1000 |      1042 |      1167 |      4875 |     10000 |
|                    Δ                     |     -2917 |     -2958 |     -2959 |     -2959 |     -2959 |     -3208 |    -17083 |         0 |
|              Improvement %               |        76 |        76 |        75 |        75 |        74 |        73 |        78 |         0 |

<p>
</details>

### Dictionary metrics

<details><summary>Time (total CPU): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (total CPU) (ns) *          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |        11 |        11 |        11 |        11 |        11 |        14 |        31 |     10000 |
|               Current_run                |         5 |         5 |         5 |         6 |         6 |         6 |        25 |     10000 |
|                    Δ                     |        -6 |        -6 |        -6 |        -5 |        -5 |        -8 |        -6 |         0 |
|              Improvement %               |        55 |        55 |        55 |        45 |        45 |        57 |        19 |         0 |

<p>
</details>

### Dictionary Small metrics

<details><summary>Time (total CPU): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (total CPU) (ns) *          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |      7292 |      7419 |      7459 |      7503 |      7667 |      8583 |     23833 |     10000 |
|               Current_run                |      2750 |      2875 |      2959 |      3001 |      3125 |      3585 |     18375 |     10000 |
|                    Δ                     |     -4542 |     -4544 |     -4500 |     -4502 |     -4542 |     -4998 |     -5458 |         0 |
|              Improvement %               |        62 |        61 |        60 |        60 |        59 |        58 |        23 |         0 |

<p>
</details>

### Int metrics

<details><summary>Time (total CPU): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (total CPU) (ns) *          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |      3874 |      3959 |      4001 |      4043 |      4127 |      4835 |     21584 |     10000 |
|               Current_run                |      1208 |      1291 |      1292 |      1333 |      1334 |      1459 |     15501 |     10000 |
|                    Δ                     |     -2666 |     -2668 |     -2709 |     -2710 |     -2793 |     -3376 |     -6083 |         0 |
|              Improvement %               |        69 |        67 |        68 |        67 |        68 |        70 |        28 |         0 |

<p>
</details>

### Int Small metrics

<details><summary>Time (total CPU): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (total CPU) (ns) *          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |      3708 |      3793 |      3833 |      3875 |      3917 |      4419 |     21792 |     10000 |
|               Current_run                |      1124 |      1208 |      1208 |      1250 |      1250 |      1375 |      5458 |     10000 |
|                    Δ                     |     -2584 |     -2585 |     -2625 |     -2625 |     -2667 |     -3044 |    -16334 |         0 |
|              Improvement %               |        70 |        68 |        68 |        68 |        68 |        69 |        75 |         0 |

<p>
</details>

### Simple Codable Object metrics

<details><summary>Time (total CPU): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (total CPU) (ns) *          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |        17 |        18 |        18 |        18 |        18 |        23 |        43 |     10000 |
|               Current_run                |         9 |         9 |         9 |         9 |        10 |        10 |        34 |     10000 |
|                    Δ                     |        -8 |        -9 |        -9 |        -9 |        -8 |       -13 |        -9 |         0 |
|              Improvement %               |        47 |        50 |        50 |        50 |        44 |        57 |        21 |         0 |

<p>
</details>

### String metrics

<details><summary>Time (total CPU): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (total CPU) (ns) *          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |      5416 |      5543 |      5583 |      5627 |      5667 |      6211 |     26459 |     10000 |
|               Current_run                |      1166 |      1250 |      1291 |      1292 |      1333 |      1499 |     24125 |     10000 |
|                    Δ                     |     -4250 |     -4293 |     -4292 |     -4335 |     -4334 |     -4712 |     -2334 |         0 |
|              Improvement %               |        78 |        77 |        77 |        77 |        76 |        76 |         9 |         0 |

<p>
</details>

### String Small metrics

<details><summary>Time (total CPU): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (total CPU) (ns) *          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |      3916 |      4001 |      4041 |      4043 |      4085 |      4419 |     28084 |     10000 |
|               Current_run                |      1000 |      1125 |      1125 |      1166 |      1167 |      1292 |      1834 |     10000 |
|                    Δ                     |     -2916 |     -2876 |     -2916 |     -2877 |     -2918 |     -3127 |    -26250 |         0 |
|              Improvement %               |        74 |        72 |        72 |        71 |        71 |        71 |        93 |         0 |

<p>
</details>

