
## Comparing results between 'json' and 'Current_run'

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
|                   json                   |        38 |        38 |        38 |        39 |        40 |        63 |       136 |     10000 |
|               Current_run                |       403 |       404 |       406 |       411 |       431 |       607 |       766 |      2389 |
|                    Δ                     |       365 |       366 |       368 |       372 |       391 |       544 |       630 |     -7611 |
|              Improvement %               |      -961 |      -963 |      -968 |      -954 |      -978 |      -863 |      -463 |     -7611 |

<p>
</details>

### Array Small metrics

<details><summary>Time (wall clock): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (wall clock) (ns) *         |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                   json                   |      2416 |      2501 |      2541 |      2543 |      2625 |      2917 |     12959 |     10000 |
|               Current_run                |      1750 |      1833 |      1875 |      1875 |      1958 |      2167 |     24583 |     10000 |
|                    Δ                     |      -666 |      -668 |      -666 |      -668 |      -667 |      -750 |     11624 |         0 |
|              Improvement %               |        28 |        27 |        26 |        26 |        25 |        26 |       -90 |         0 |

<p>
</details>

### Bool metrics

<details><summary>Time (wall clock): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (wall clock) (ns) *         |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                   json                   |      2166 |      2251 |      2251 |      2293 |      2333 |      2543 |     12417 |     10000 |
|               Current_run                |       291 |       334 |       375 |       375 |       375 |       459 |     11209 |     10000 |
|                    Δ                     |     -1875 |     -1917 |     -1876 |     -1918 |     -1958 |     -2084 |     -1208 |         0 |
|              Improvement %               |        87 |        85 |        83 |        84 |        84 |        82 |        10 |         0 |

<p>
</details>

### Complex Codable Object metrics

<details><summary>Time (wall clock): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (wall clock) (μs) *         |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                   json                   |        47 |        47 |        47 |        48 |        49 |        54 |        91 |     10000 |
|               Current_run                |        83 |        84 |        84 |        85 |        87 |       106 |       215 |     10000 |
|                    Δ                     |        36 |        37 |        37 |        37 |        38 |        52 |       124 |         0 |
|              Improvement %               |       -77 |       -79 |       -79 |       -77 |       -78 |       -96 |      -136 |         0 |

<p>
</details>

### Data metrics

<details><summary>Time (wall clock): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (wall clock) (ns) *         |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                   json                   |        43 |        43 |        43 |        43 |        45 |        50 |        81 |     10000 |
|               Current_run                |         0 |         0 |         0 |         0 |         0 |         0 |         2 |     10000 |
|                    Δ                     |       -43 |       -43 |       -43 |       -43 |       -45 |       -50 |       -79 |         0 |
|              Improvement %               |         0 |         0 |         0 |         0 |         0 |         0 |        98 |         0 |

<p>
</details>

### Data Small metrics

<details><summary>Time (wall clock): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (wall clock) (ns) *         |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                   json                   |      3416 |      3501 |      3501 |      3543 |      3625 |      3959 |     19917 |     10000 |
|               Current_run                |        41 |       125 |       125 |       166 |       167 |       208 |       792 |     10000 |
|                    Δ                     |     -3375 |     -3376 |     -3376 |     -3377 |     -3458 |     -3751 |    -19125 |         0 |
|              Improvement %               |        99 |        96 |        96 |        95 |        95 |        95 |        96 |         0 |

<p>
</details>

### Dictionary metrics

<details><summary>Time (wall clock): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (wall clock) (ns) *         |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                   json                   |      9375 |      9543 |      9583 |      9631 |      9839 |     10631 |     30167 |     10000 |
|               Current_run                |      4166 |      4335 |      4419 |      4503 |      4583 |      4875 |     14208 |     10000 |
|                    Δ                     |     -5209 |     -5208 |     -5164 |     -5128 |     -5256 |     -5756 |    -15959 |         0 |
|              Improvement %               |        56 |        55 |        54 |        53 |        53 |        54 |        53 |         0 |

<p>
</details>

### Dictionary Small metrics

<details><summary>Time (wall clock): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (wall clock) (ns) *         |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                   json                   |      5208 |      5335 |      5375 |      5419 |      5543 |      6167 |     31167 |     10000 |
|               Current_run                |      1916 |      2000 |      2000 |      2042 |      2125 |      2335 |      8334 |     10000 |
|                    Δ                     |     -3292 |     -3335 |     -3375 |     -3377 |     -3418 |     -3832 |    -22833 |         0 |
|              Improvement %               |        63 |        63 |        63 |        62 |        62 |        62 |        73 |         0 |

<p>
</details>

### Int metrics

<details><summary>Time (wall clock): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (wall clock) (ns) *         |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                   json                   |      2208 |      2293 |      2333 |      2335 |      2375 |      2625 |     17667 |     10000 |
|               Current_run                |       375 |       458 |       500 |       500 |       500 |       583 |     17083 |     10000 |
|                    Δ                     |     -1833 |     -1835 |     -1833 |     -1835 |     -1875 |     -2042 |      -584 |         0 |
|              Improvement %               |        83 |        80 |        79 |        79 |        79 |        78 |         3 |         0 |

<p>
</details>

### Int Small metrics

<details><summary>Time (wall clock): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (wall clock) (ns) *         |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                   json                   |      2250 |      2333 |      2335 |      2375 |      2417 |      2751 |     22167 |     10000 |
|               Current_run                |       416 |       500 |       500 |       500 |       542 |       584 |      1459 |     10000 |
|                    Δ                     |     -1834 |     -1833 |     -1835 |     -1875 |     -1875 |     -2167 |    -20708 |         0 |
|              Improvement %               |        82 |        79 |        79 |        79 |        78 |        79 |        93 |         0 |

<p>
</details>

### Simple Codable Object metrics

<details><summary>Time (wall clock): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (wall clock) (ns) *         |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                   json                   |        10 |        10 |        10 |        10 |        11 |        11 |        28 |     10000 |
|               Current_run                |         7 |         8 |         8 |         8 |         8 |         9 |        28 |     10000 |
|                    Δ                     |        -3 |        -2 |        -2 |        -2 |        -3 |        -2 |         0 |         0 |
|              Improvement %               |        30 |        20 |        20 |        20 |        27 |        18 |         0 |         0 |

<p>
</details>

### String metrics

<details><summary>Time (wall clock): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (wall clock) (ns) *         |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                   json                   |      5291 |      5375 |      5419 |      5459 |      5543 |      5959 |     19084 |     10000 |
|               Current_run                |       458 |       542 |       583 |       584 |       625 |      1709 |     26250 |     10000 |
|                    Δ                     |     -4833 |     -4833 |     -4836 |     -4875 |     -4918 |     -4250 |      7166 |         0 |
|              Improvement %               |        91 |        90 |        89 |        89 |        89 |        71 |       -38 |         0 |

<p>
</details>

### String Small metrics

<details><summary>Time (wall clock): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (wall clock) (ns) *         |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                   json                   |      2208 |      2293 |      2333 |      2375 |      2459 |      3001 |     68458 |     10000 |
|               Current_run                |       333 |       375 |       416 |       417 |       458 |       625 |     24458 |     10000 |
|                    Δ                     |     -1875 |     -1918 |     -1917 |     -1958 |     -2001 |     -2376 |    -44000 |         0 |
|              Improvement %               |        85 |        84 |        82 |        82 |        81 |        79 |        64 |         0 |

<p>
</details>
