# 01 — System Overview

## Motivation

Antenna impedance changes with frequency and nearby objects. When the antenna deviates from the RF-system reference impedance, part of the incident power is reflected. The adaptive matching network is inserted between source and antenna to reduce this mismatch automatically.

The project uses a tunable L-network because it offers a compact two-reactive-element structure with a useful orthogonal interpretation:

- the **parallel LC section** controls the real part of the equivalent impedance;
- the **series LC section** cancels the remaining reactance.

## Signal flow

```text
RF source, Z0 = 50 ohm
        |
        v
Series LC  <-------------------- 2nd control loop
        |
      ZINT
        |
Parallel LC <------------------- 1st control loop
        |
     ZLOAD (antenna)
```

The physical controller senses RF voltage and current, derives real and imaginary impedance information, extracts the signs of the corresponding errors, and uses Up/Down counters to control switched-capacitor arrays.

## Baseline design

| Parameter | Value |
|---|---:|
| Reference impedance | 50 Ω |
| Operating bands | 900 / 1800 MHz |
| Maximum benchmark mismatch | VSWR 4.3 |
| Parallel inductor | 6 nH |
| Series inductor | 12 nH |
| Parallel capacitor range | 0.5–7.0 pF |
| Series capacitor range | 0.5–7.0 pF |
| Benchmark element quality factor | 50 |

## Repository goal

The original course work contains extensive derivations and ADS evaluation. This repository compresses that material into a reusable MATLAB digital twin with three priorities:

1. reproduce the benchmark A–F calculations;
2. expose the physics through phase sweeps and Smith-chart plots;
3. animate impedance convergence in the same intuitive way that a trajectory-tracking project animates a vehicle moving from start to goal.
