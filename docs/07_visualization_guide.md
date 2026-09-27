# 07 — Visualization Guide

This repository is intentionally more visual than the original report.

## 1. Case summary

`plot_case_summary.m` answers:

- Which load is hardest to match?
- How much capacitance is required?
- How much insertion loss is paid?
- Is the final power gain still positive?

## 2. PhaseGammaLoad sweep

`plot_phase_sweep.m` parameterizes a constant-VSWR circle using

$$
\Gamma_{LOAD}=\rho e^{j\phi},
\qquad
\rho=\frac{VSWR-1}{VSWR+1}.
$$

The corresponding load is

$$
Z_{LOAD}=Z_0\frac{1+\Gamma_{LOAD}}{1-\Gamma_{LOAD}}.
$$

For each phase, the code solves the required capacitors and plots $IL$, $G$, residual VSWR, and tuning feasibility.

This is the cleanest way to connect the Smith-chart geometry to the performance curves used in the IEEE paper.

## 3. Impedance tracking animation

`simulate_aim_tracking.m` + `animate_smith_tracking.m` create the RF analogue of a trajectory-tracking animation.

```text
start = mismatched ZLOAD
path  = sequence of discrete capacitor states
state = Zin(CPAR, CSERIES)
goal  = 50 + j0 ohm
```

The animation displays four synchronized views:

- Smith-chart trajectory;
- capacitor states;
- VSWR history;
- real and imaginary parts of the input impedance.

This is recommended as the hero GIF for the GitHub README because it makes the AIM idea understandable before the reader studies the equations.

## 4. Recommended README figure order

1. Smith-chart tracking GIF.
2. 900-MHz case summary.
3. 1800-MHz case summary.
4. PhaseGammaLoad sweep.
5. Optional hardware/control architecture diagram.
