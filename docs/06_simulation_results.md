# 06 — Simulation Results

The repository reproduces the analytical benchmark behind the six antenna-load scenarios.

## 900 MHz

| Case | $C_{PAR}$ [pF] | $C_{SERIES}$ [pF] | IL [dB] | G [dB] |
|---|---:|---:|---:|---:|
| A | 5.21 | 2.61 | 0.47 | -0.47 |
| B | 3.68 | 1.14 | 1.11 | 0.83 |
| C | 5.21 | 1.24 | 1.06 | 0.88 |
| D | 1.95 | 1.24 | 0.85 | 1.09 |
| E | 6.31 | 1.37 | 0.94 | 1.19 |
| F | 0.65 | 1.37 | 0.65 | 1.48 |

## 1800 MHz

| Case | $C_{PAR}$ [pF] | $C_{SERIES}$ [pF] | IL [dB] | G [dB] |
|---|---:|---:|---:|---:|
| A | 1.30 | 0.65 | 0.56 | -0.56 |
| B | 2.07 | 1.80 | 0.89 | 1.05 |
| C | 2.94 | 1.46 | 0.91 | 1.03 |
| D | 1.30 | 1.46 | 0.70 | 1.24 |
| E | 3.58 | 1.19 | 0.87 | 1.26 |
| F | 0.76 | 1.19 | 0.58 | 1.55 |

Small differences in residual VSWR can occur when comparing this compact finite-Q model with a full ADS network, because ADS can include implementation details beyond the first-order loss model used here.

## Interpretation

Case A demonstrates the cost of unnecessary matching: no reflection-loss reduction is available, so finite component loss makes the net gain negative.

Cases B–F show the intended operating regime. Their original VSWR values are approximately 4–4.3, and the adaptive network recovers around 1 dB of net delivered power depending on load and frequency.
