## Comparing results between 'swiftcbor' and 'Current_run'

```
Host 'Khans-MacBook-Pro.local' with 10 'arm64' processors with 16 GB memory, running:
Darwin Kernel Version 24.3.0: Thu Jan  2 20:24:16 PST 2025; root:xnu-11215.81.4~3/RELEASE_ARM64_T6000
```
## Benchmarks

### Array metrics

<details><summary>Time (wall clock): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (wall clock) (μs) *         |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |       663 |       665 |       669 |       681 |       714 |      1366 |      4178 |      1322 |
|               Current_run                |       395 |       395 |       395 |       398 |       402 |       417 |       455 |      2505 |
|                    Δ                     |      -268 |      -270 |      -274 |      -283 |      -312 |      -949 |     -3723 |      1183 |
|              Improvement %               |        40 |        41 |        41 |        42 |        44 |        69 |        89 |      1183 |

<p>
</details>

### Array Small metrics

<details><summary>Time (wall clock): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (wall clock) (ns) *         |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |      5333 |      5459 |      5503 |      5627 |      5919 |      9751 |     71500 |     10000 |
|               Current_run                |      1792 |      1916 |      1917 |      1959 |      2000 |      2209 |      6291 |     10000 |
|                    Δ                     |     -3541 |     -3543 |     -3586 |     -3668 |     -3919 |     -7542 |    -65209 |         0 |
|              Improvement %               |        66 |        65 |        65 |        65 |        66 |        77 |        91 |         0 |

<p>
</details>

### Bool metrics

<details><summary>Time (wall clock): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (wall clock) (ns) *         |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |      1416 |      1500 |      1500 |      1583 |      1667 |      3543 |     36125 |     10000 |
|               Current_run                |       292 |       375 |       375 |       416 |       417 |       459 |      6417 |     10000 |
|                    Δ                     |     -1124 |     -1125 |     -1125 |     -1167 |     -1250 |     -3084 |    -29708 |         0 |
|              Improvement %               |        79 |        75 |        75 |        74 |        75 |        87 |        82 |         0 |

<p>
</details>

### Complex Codable Object metrics

<details><summary>Time (wall clock): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (wall clock) (μs) *         |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |       122 |       123 |       123 |       125 |       129 |       166 |       247 |      5747 |
|               Current_run                |        81 |        82 |        82 |        82 |        84 |        91 |       196 |     10000 |
|                    Δ                     |       -41 |       -41 |       -41 |       -43 |       -45 |       -75 |       -51 |      4253 |
|              Improvement %               |        34 |        33 |        33 |        34 |        35 |        45 |        21 |      4253 |

<p>
</details>

### Data metrics

<details><summary>Time (wall clock): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (wall clock) (ns) *         |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |      3416 |      3501 |      3543 |      3585 |      3709 |      4167 |    106459 |     10000 |
|               Current_run                |       208 |       291 |       292 |       292 |       292 |       458 |     16667 |     10000 |
|                    Δ                     |     -3208 |     -3210 |     -3251 |     -3293 |     -3417 |     -3709 |    -89792 |         0 |
|              Improvement %               |        94 |        92 |        92 |        92 |        92 |        89 |        84 |         0 |

<p>
</details>

### Data Small metrics

<details><summary>Time (wall clock): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (wall clock) (ns) *         |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |      2083 |      2167 |      2167 |      2209 |      2333 |      3291 |     33125 |     10000 |
|               Current_run                |        83 |       125 |       125 |       166 |       167 |       208 |      2583 |     10000 |
|                    Δ                     |     -2000 |     -2042 |     -2042 |     -2043 |     -2166 |     -3083 |    -30542 |         0 |
|              Improvement %               |        96 |        94 |        94 |        92 |        93 |        94 |        92 |         0 |

<p>
</details>

### Dictionary metrics

<details><summary>Time (wall clock): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (wall clock) (ns) *         |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |         9 |         9 |         9 |        10 |        10 |        23 |      1942 |     10000 |
|               Current_run                |         4 |         4 |         4 |         4 |         4 |         5 |        21 |     10000 |
|                    Δ                     |        -5 |        -5 |        -5 |        -6 |        -6 |       -18 |     -1921 |         0 |
|              Improvement %               |        56 |        56 |        56 |        60 |        60 |        78 |        99 |         0 |

<p>
</details>

### Dictionary Small metrics

<details><summary>Time (wall clock): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (wall clock) (ns) *         |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |      5583 |      5711 |      5711 |      5751 |      5919 |      6543 |     31917 |     10000 |
|               Current_run                |      1791 |      1916 |      1958 |      2000 |      2042 |      2293 |      8334 |     10000 |
|                    Δ                     |     -3792 |     -3795 |     -3753 |     -3751 |     -3877 |     -4250 |    -23583 |         0 |
|              Improvement %               |        68 |        66 |        66 |        65 |        66 |        65 |        74 |         0 |

<p>
</details>

### Int metrics

<details><summary>Time (wall clock): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (wall clock) (ns) *         |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |      2083 |      2167 |      2209 |      2209 |      2251 |      2459 |     15000 |     10000 |
|               Current_run                |       375 |       458 |       458 |       459 |       500 |       583 |      2208 |     10000 |
|                    Δ                     |     -1708 |     -1709 |     -1751 |     -1750 |     -1751 |     -1876 |    -12792 |         0 |
|              Improvement %               |        82 |        79 |        79 |        79 |        78 |        76 |        85 |         0 |

<p>
</details>

### Int Small metrics

<details><summary>Time (wall clock): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (wall clock) (ns) *         |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |      2041 |      2125 |      2125 |      2125 |      2167 |      2417 |     36958 |     10000 |
|               Current_run                |       375 |       458 |       458 |       459 |       500 |       542 |      1250 |     10000 |
|                    Δ                     |     -1666 |     -1667 |     -1667 |     -1666 |     -1667 |     -1875 |    -35708 |         0 |
|              Improvement %               |        82 |        78 |        78 |        78 |        77 |        78 |        97 |         0 |

<p>
</details>

### Simple Codable Object metrics

<details><summary>Time (wall clock): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (wall clock) (ns) *         |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |        16 |        16 |        16 |        16 |        16 |        18 |        37 |     10000 |
|               Current_run                |         7 |         7 |         8 |         8 |         8 |         9 |        26 |     10000 |
|                    Δ                     |        -9 |        -9 |        -8 |        -8 |        -8 |        -9 |       -11 |         0 |
|              Improvement %               |        56 |        56 |        50 |        50 |        50 |        50 |        30 |         0 |

<p>
</details>

### String metrics

<details><summary>Time (wall clock): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (wall clock) (ns) *         |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |      3750 |      3833 |      3875 |      3917 |      4041 |      5043 |     31000 |     10000 |
|               Current_run                |       458 |       500 |       541 |       542 |       542 |       667 |      3209 |     10000 |
|                    Δ                     |     -3292 |     -3333 |     -3334 |     -3375 |     -3499 |     -4376 |    -27791 |         0 |
|              Improvement %               |        88 |        87 |        86 |        86 |        87 |        87 |        90 |         0 |

<p>
</details>

### String Small metrics

<details><summary>Time (wall clock): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (wall clock) (ns) *         |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |      2208 |      2293 |      2333 |      2335 |      2375 |      2625 |     12000 |     10000 |
|               Current_run                |       291 |       375 |       375 |       417 |       417 |       500 |      7583 |     10000 |
|                    Δ                     |     -1917 |     -1918 |     -1958 |     -1918 |     -1958 |     -2125 |     -4417 |         0 |
|              Improvement %               |        87 |        84 |        84 |        82 |        82 |        81 |        37 |         0 |

<p>
</details>
