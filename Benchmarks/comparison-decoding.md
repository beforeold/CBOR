
## Comparing results between 'swiftcbor' and 'Current_run'

```
Host 'Khans-MacBook-Pro.local' with 10 'arm64' processors with 16 GB memory, running:
Darwin Kernel Version 24.3.0: Thu Jan  2 20:24:16 PST 2025; root:xnu-11215.81.4~3/RELEASE_ARM64_T6000
```
## Decoding

### Array metrics

<details><summary>Time (total CPU): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (total CPU) (ns) *          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |        22 |        23 |        23 |        23 |        24 |        34 |        59 |     10000 |
|               Current_run                |         6 |         7 |         7 |         7 |         7 |         7 |        24 |     10000 |
|                    Δ                     |       -16 |       -16 |       -16 |       -16 |       -17 |       -27 |       -35 |         0 |
|              Improvement %               |        73 |        70 |        70 |        70 |        71 |        79 |        59 |         0 |

<p>
</details>

### Complex Object metrics

<details><summary>Time (total CPU): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (total CPU) (μs) *          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |       698 |       700 |       703 |       709 |       723 |       761 |       824 |      1229 |
|               Current_run                |        74 |        74 |        75 |        75 |        77 |        83 |       104 |      8115 |
|                    Δ                     |      -624 |      -626 |      -628 |      -634 |      -646 |      -678 |      -720 |      6886 |
|              Improvement %               |        89 |        89 |        89 |        89 |        89 |        89 |        87 |      6886 |

<p>
</details>

### Date metrics

<details><summary>Time (total CPU): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (total CPU) (ns) *          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |      5125 |      5211 |      5251 |      5291 |      5375 |      5875 |     19500 |     10000 |
|               Current_run                |       959 |      1042 |      1083 |      1084 |      1125 |      1250 |      8749 |     10000 |
|                    Δ                     |     -4166 |     -4169 |     -4168 |     -4207 |     -4250 |     -4625 |    -10751 |         0 |
|              Improvement %               |        81 |        80 |        79 |        80 |        79 |        79 |        55 |         0 |

<p>
</details>

### Dictionary metrics

<details><summary>Time (total CPU): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (total CPU) (ns) *          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |        17 |        17 |        17 |        17 |        18 |        23 |        35 |     10000 |
|               Current_run                |         5 |         5 |         5 |         5 |         5 |         6 |        19 |     10000 |
|                    Δ                     |       -12 |       -12 |       -12 |       -12 |       -13 |       -17 |       -16 |         0 |
|              Improvement %               |        71 |        71 |        71 |        71 |        72 |        74 |        46 |         0 |

<p>
</details>

### Double metrics

<details><summary>Time (total CPU): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (total CPU) (ns) *          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |      5166 |      5251 |      5295 |      5335 |      5419 |      6087 |     24041 |     10000 |
|               Current_run                |       916 |      1000 |      1001 |      1042 |      1083 |      1208 |     19666 |     10000 |
|                    Δ                     |     -4250 |     -4251 |     -4294 |     -4293 |     -4336 |     -4879 |     -4375 |         0 |
|              Improvement %               |        82 |        81 |        81 |        80 |        80 |        80 |        18 |         0 |

<p>
</details>

### Float metrics

<details><summary>Time (total CPU): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (total CPU) (ns) *          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |      5166 |      5251 |      5295 |      5335 |      5375 |      5959 |     24875 |     10000 |
|               Current_run                |       916 |      1000 |      1000 |      1041 |      1042 |      1167 |      8417 |     10000 |
|                    Δ                     |     -4250 |     -4251 |     -4295 |     -4294 |     -4333 |     -4792 |    -16458 |         0 |
|              Improvement %               |        82 |        81 |        81 |        80 |        81 |        80 |        66 |         0 |

<p>
</details>

### Indeterminate String metrics

<details><summary>Time (total CPU): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (total CPU) (ns) *          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |      6124 |      6251 |      6251 |      6295 |      6375 |      7003 |     36250 |     10000 |
|               Current_run                |      1292 |      1375 |      1417 |      1458 |      1500 |      1750 |      8459 |     10000 |
|                    Δ                     |     -4832 |     -4876 |     -4834 |     -4837 |     -4875 |     -5253 |    -27791 |         0 |
|              Improvement %               |        79 |        78 |        77 |        77 |        76 |        75 |        77 |         0 |

<p>
</details>

### Int metrics

<details><summary>Time (total CPU): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (total CPU) (ns) *          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |      5083 |      5211 |      5211 |      5251 |      5335 |      5919 |     19542 |     10000 |
|               Current_run                |      1041 |      1124 |      1125 |      1166 |      1167 |      1292 |     20833 |     10000 |
|                    Δ                     |     -4042 |     -4087 |     -4086 |     -4085 |     -4168 |     -4627 |      1291 |         0 |
|              Improvement %               |        80 |        78 |        78 |        78 |        78 |        78 |        -7 |         0 |

<p>
</details>

### Int Small metrics

<details><summary>Time (total CPU): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (total CPU) (ns) *          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |      5082 |      5167 |      5211 |      5211 |      5291 |      5711 |     20708 |     10000 |
|               Current_run                |       958 |      1083 |      1083 |      1125 |      1125 |      1250 |     16792 |     10000 |
|                    Δ                     |     -4124 |     -4084 |     -4128 |     -4086 |     -4166 |     -4461 |     -3916 |         0 |
|              Improvement %               |        81 |        79 |        79 |        78 |        79 |        78 |        19 |         0 |

<p>
</details>

### Simple Object metrics

<details><summary>Time (total CPU): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (total CPU) (ns) *          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |        35 |        36 |        36 |        37 |        37 |        43 |        56 |     10000 |
|               Current_run                |         8 |         8 |         8 |         8 |         8 |         9 |        21 |     10000 |
|                    Δ                     |       -27 |       -28 |       -28 |       -29 |       -29 |       -34 |       -35 |         0 |
|              Improvement %               |        77 |        78 |        78 |        78 |        78 |        79 |        62 |         0 |

<p>
</details>

### String metrics

<details><summary>Time (total CPU): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (total CPU) (ns) *          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |      5293 |      5419 |      5459 |      5459 |      5503 |      5959 |     20499 |     10000 |
|               Current_run                |      1166 |      1251 |      1292 |      1333 |      1334 |      1583 |     15584 |     10000 |
|                    Δ                     |     -4127 |     -4168 |     -4167 |     -4126 |     -4169 |     -4376 |     -4915 |         0 |
|              Improvement %               |        78 |        77 |        76 |        76 |        76 |        73 |        24 |         0 |

<p>
</details>

### String Small metrics

<details><summary>Time (total CPU): results within specified thresholds, fold down for details.</summary>
<p>

|         Time (total CPU) (ns) *          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |      5124 |      5251 |      5291 |      5335 |      5459 |      6295 |     25084 |     10000 |
|               Current_run                |      1041 |      1125 |      1126 |      1167 |      1208 |      1334 |      9250 |     10000 |
|                    Δ                     |     -4083 |     -4126 |     -4165 |     -4168 |     -4251 |     -4961 |    -15834 |         0 |
|              Improvement %               |        80 |        79 |        79 |        78 |        78 |        79 |        63 |         0 |

<p>
</details>
