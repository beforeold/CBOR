
## Comparing results between 'swiftcbor' and 'Current_run'

```
Host 'Khans-MacBook-Pro.local' with 10 'arm64' processors with 16 GB memory, running:
Darwin Kernel Version 24.3.0: Thu Jan  2 20:24:16 PST 2025; root:xnu-11215.81.4~3/RELEASE_ARM64_T6000
```
## Benchmarks

### Array metrics

<details><summary>Throughput (# / s): results within specified thresholds, fold down for details.</summary>
<p>

|          Throughput (# / s) (#)          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |      1509 |      1505 |      1496 |      1469 |      1401 |       732 |       239 |      1322 |
|               Current_run                |      2512 |      2509 |      2505 |      2489 |      2449 |      2297 |      1900 |      2476 |
|                    Δ                     |      1003 |      1004 |      1009 |      1020 |      1048 |      1565 |      1661 |      1154 |
|              Improvement %               |        66 |        67 |        67 |        69 |        75 |       214 |       695 |      1154 |

<p>
</details>

### Array Small metrics

<details><summary>Throughput (# / s): results within specified thresholds, fold down for details.</summary>
<p>

|          Throughput (# / s) (K)          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |       188 |       183 |       182 |       178 |       169 |       102 |        14 |     10000 |
|               Current_run                |       558 |       534 |       534 |       522 |       511 |       480 |        72 |     10000 |
|                    Δ                     |       370 |       351 |       352 |       344 |       342 |       378 |        58 |         0 |
|              Improvement %               |       197 |       192 |       193 |       193 |       202 |       371 |       414 |         0 |

<p>
</details>

### Bool metrics

<details><summary>Throughput (# / s): results within specified thresholds, fold down for details.</summary>
<p>

|          Throughput (# / s) (K)          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |       706 |       667 |       667 |       632 |       600 |       282 |        28 |     10000 |
|               Current_run                |      3436 |      2669 |      2669 |      2669 |      2398 |      2185 |       296 |     10000 |
|                    Δ                     |      2730 |      2002 |      2002 |      2037 |      1798 |      1903 |       268 |         0 |
|              Improvement %               |       387 |       300 |       300 |       322 |       300 |       675 |       957 |         0 |

<p>
</details>

### Complex Codable Object metrics

<details><summary>Throughput (# / s): results within specified thresholds, fold down for details.</summary>
<p>

|          Throughput (# / s) (K)          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |      8180 |      8147 |      8127 |      7995 |      7751 |      6019 |      4044 |      5747 |
|               Current_run                |     12245 |     12183 |     12159 |     12103 |     11751 |     10919 |      8003 |     10000 |
|                    Δ                     |      4065 |      4036 |      4032 |      4108 |      4000 |      4900 |      3959 |      4253 |
|              Improvement %               |        50 |        50 |        50 |        51 |        52 |        81 |        98 |      4253 |

<p>
</details>

### Data metrics

<details><summary>Throughput (# / s): results within specified thresholds, fold down for details.</summary>
<p>

|          Throughput (# / s) (K)          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |       293 |       286 |       282 |       279 |       270 |       240 |         9 |     10000 |
|               Current_run                |      4808 |      4002 |      3437 |      3426 |      3426 |      2669 |       533 |     10000 |
|                    Δ                     |      4515 |      3716 |      3155 |      3147 |      3156 |      2429 |       524 |         0 |
|              Improvement %               |      1541 |      1299 |      1119 |      1128 |      1169 |      1012 |      5822 |         0 |

<p>
</details>

### Data Small metrics

<details><summary>Throughput (# / s): results within specified thresholds, fold down for details.</summary>
<p>

|          Throughput (# / s) (K)          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |       480 |       462 |       462 |       453 |       429 |       304 |        30 |     10000 |
|               Current_run                |     12048 |      8004 |      6025 |      5988 |      5988 |      4788 |      1333 |     10000 |
|                    Δ                     |     11568 |      7542 |      5563 |      5535 |      5559 |      4484 |      1303 |         0 |
|              Improvement %               |      2410 |      1632 |      1204 |      1222 |      1296 |      1475 |      4343 |         0 |

<p>
</details>

### Dictionary metrics

<details><summary>Throughput (# / s): results within specified thresholds, fold down for details.</summary>
<p>

|          Throughput (# / s) (K)          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |       110 |       108 |       107 |       104 |        99 |        43 |         1 |     10000 |
|               Current_run                |       245 |       238 |       233 |       229 |       226 |       211 |        49 |     10000 |
|                    Δ                     |       135 |       130 |       126 |       125 |       127 |       168 |        48 |         0 |
|              Improvement %               |       123 |       120 |       118 |       120 |       128 |       391 |      4800 |         0 |

<p>
</details>

### Dictionary Small metrics

<details><summary>Throughput (# / s): results within specified thresholds, fold down for details.</summary>
<p>

|          Throughput (# / s) (K)          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |       179 |       175 |       175 |       174 |       169 |       153 |        31 |     10000 |
|               Current_run                |       533 |       522 |       511 |       500 |       480 |       436 |       104 |     10000 |
|                    Δ                     |       354 |       347 |       336 |       326 |       311 |       283 |        73 |         0 |
|              Improvement %               |       198 |       198 |       192 |       187 |       184 |       185 |       235 |         0 |

<p>
</details>

### Int metrics

<details><summary>Throughput (# / s): results within specified thresholds, fold down for details.</summary>
<p>

|          Throughput (# / s) (K)          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |       480 |       462 |       453 |       453 |       445 |       407 |        67 |     10000 |
|               Current_run                |      2404 |      2185 |      2179 |      2001 |      2001 |      1845 |       200 |     10000 |
|                    Δ                     |      1924 |      1723 |      1726 |      1548 |      1556 |      1438 |       133 |         0 |
|              Improvement %               |       401 |       373 |       381 |       342 |       350 |       353 |       199 |         0 |

<p>
</details>

### Int Small metrics

<details><summary>Throughput (# / s): results within specified thresholds, fold down for details.</summary>
<p>

|          Throughput (# / s) (K)          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |       490 |       471 |       471 |       471 |       462 |       414 |        27 |     10000 |
|               Current_run                |      2667 |      2185 |      2179 |      2001 |      2001 |      1716 |       195 |     10000 |
|                    Δ                     |      2177 |      1714 |      1708 |      1530 |      1539 |      1302 |       168 |         0 |
|              Improvement %               |       444 |       364 |       363 |       325 |       333 |       314 |       622 |         0 |

<p>
</details>

### Simple Codable Object metrics

<details><summary>Throughput (# / s): results within specified thresholds, fold down for details.</summary>
<p>

|          Throughput (# / s) (K)          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |        64 |        63 |        63 |        63 |        62 |        56 |        27 |     10000 |
|               Current_run                |       136 |       134 |       131 |       130 |       126 |       117 |        37 |     10000 |
|                    Δ                     |        72 |        71 |        68 |        67 |        64 |        61 |        10 |         0 |
|              Improvement %               |       112 |       113 |       108 |       106 |       103 |       109 |        37 |         0 |

<p>
</details>

### String metrics

<details><summary>Throughput (# / s): results within specified thresholds, fold down for details.</summary>
<p>

|          Throughput (# / s) (K)          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |       267 |       261 |       258 |       255 |       248 |       198 |        32 |     10000 |
|               Current_run                |      2183 |      2001 |      1849 |      1845 |      1845 |      1601 |       461 |     10000 |
|                    Δ                     |      1916 |      1740 |      1591 |      1590 |      1597 |      1403 |       429 |         0 |
|              Improvement %               |       718 |       667 |       617 |       624 |       644 |       709 |      1341 |         0 |

<p>
</details>

### String Small metrics

<details><summary>Throughput (# / s): results within specified thresholds, fold down for details.</summary>
<p>

|          Throughput (# / s) (K)          |        p0 |       p25 |       p50 |       p75 |       p90 |       p99 |      p100 |   Samples |
|:----------------------------------------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|----------:|
|                swiftcbor                 |       453 |       436 |       429 |       429 |       421 |       381 |        83 |     10000 |
|               Current_run                |      3003 |      2669 |      2404 |      2398 |      2398 |      2179 |       276 |     10000 |
|                    Δ                     |      2550 |      2233 |      1975 |      1969 |      1977 |      1798 |       193 |         0 |
|              Improvement %               |       563 |       512 |       460 |       459 |       470 |       472 |       233 |         0 |

<p>
</details>
