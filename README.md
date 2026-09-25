# Adaptive Impedance Matching of a Dual-Band L-Network for GSM900/1800 Application

# Adaptive Impedance Matching of a Dual-Band L-Network for GSM900/1800 Application

> This repository is a compact software companion to a Microwave Engineering project at Ho Chi Minh City University of Technology (HCMUT - VNU).
>
> It studies **Adaptive Impedance Matching (AIM)** using a tunable **L-network** with two cascaded control loops: a shunt branch for the real part of the matched impedance and a series branch for the residual reactance.
>
> The MATLAB implementation is intentionally visualization-oriented: analytical design, finite-Q evaluation, phase-sweep studies, A–F benchmark cases, and a Smith-chart tracking animation showing how the impedance moves from the initial mismatch toward the 50-Ω target.
>
> During the development of this project, several research papers on **Adaptive Impedance Matching (AIM)** were reviewed. In particular, **[1](#references)** served as an important reference for the adaptive control concept and tunable L-network analysis.
>
> The project was developed as part of a **Microwave Engineering course project at HCMUT - VNU**, where the concepts of impedance matching, tunable L-networks, and adaptive control were studied and applied to a dual-band GSM900/1800 application.

---

## References

[1] A. van Bezooijen, M. A. de Jongh, F. van Straten, R. Mahmoudi, and A. H. M. van Roermund, “Adaptive Impedance-Matching Techniques for Controlling L Networks,” *IEEE Transactions on Circuits and Systems I: Regular Papers*, vol. 57, no. 2, pp. 495–505, Feb. 2010. [DOI: 10.1109/TCSI.2009.2023764](https://doi.org/10.1109/TCSI.2009.2023764).

[2] HCMUT Microwave Engineering Course Project, “Analysis and Tuning of L-Network Impedance Matching Under Antenna Impedance Variations Using Adaptive Control Techniques,” Group 06, 2026.
A hierarchical view of the repository is

![Smith-chart AIM tracking](pics/sim/smith_tracking_case_E_900MHz.gif)

$$
Z_{LOAD}
\rightarrow \text{Shunt LC / 1st loop}
\rightarrow Z_{INT}
\rightarrow \text{Series LC / 2nd loop}
\rightarrow Z_{MATCH}
\rightarrow \{\Gamma,\ VSWR,\ IL,\ G\}.
$$

---

## 1. System Overview

The design uses a down-converting L-network between a 50-Ω RF source and a varying antenna load.

- **Shunt branch (1st loop):** fixed $L_{PAR}$ in parallel with tunable $C_{PAR}$.
- **Series branch (2nd loop):** fixed $L_{SERIES}$ in series with tunable $C_{SERIES}$.
- **Target:** $Z_{MATCH}=50+j0\ \Omega$.
- **Bands:** 900 MHz and 1800 MHz.
- **Tunable capacitors:** 0.5–7.0 pF.
- **Nominal inductors:** $L_{PAR}=6$ nH and $L_{SERIES}=12$ nH.
- **Finite component quality factor used for benchmark evaluation:** $Q_e=50$.

The project follows the core control idea of van Bezooijen *et al.*: two cascaded loops independently regulate the real and imaginary parts of impedance, while a secondary sign criterion is used to avoid the ambiguous region of the parallel branch.

---

## 2. L-Network Mathematical Model

For

$$
Y_{LOAD}=G_{LOAD}+jB_{LOAD}=\frac{1}{Z_{LOAD}},
$$

the intermediate admittance after the shunt branch is

$$
Y_{INT}=G_{LOAD}+j\left(B_{LOAD}+\omega C_{PAR}-\frac{1}{\omega L_{PAR}}\right).
$$

Define

$$
B_{INT}=B_{LOAD}+\omega C_{PAR}-\frac{1}{\omega L_{PAR}}.
$$

Then

$$
Z_{INT}=\frac{1}{G_{LOAD}+jB_{INT}}=R_{INT}+jX_{INT}.
$$

The first loop chooses $C_{PAR}$ so that

$$
R_{INT}=R_{REF}=50\ \Omega.
$$

This yields

$$
B_{INT}=\pm\sqrt{\frac{G_{LOAD}}{R_{REF}}-G_{LOAD}^{2}}.
$$

The corresponding shunt capacitance is

$$
C_{PAR}=\frac{1}{\omega}\left(B_{INT}-B_{LOAD}+\frac{1}{\omega L_{PAR}}\right).
$$

The second loop cancels the remaining reactance using

$$
X_{SERIES}=\omega L_{SERIES}-\frac{1}{\omega C_{SERIES}},
$$

so that

$$
X_{MATCH}=X_{INT}+X_{SERIES}=X_{REF}.
$$

Therefore,

$$
C_{SERIES}=\frac{1}{\omega\left(\omega L_{SERIES}+X_{INT}-X_{REF}\right)}.
$$

For the benchmark design, the **inductive intermediate solution** is used at 900 MHz and the **capacitive intermediate solution** at 1800 MHz.

---

## 3. Performance Metrics

Reflection coefficient:

$$
\Gamma=\frac{Z-Z_0}{Z+Z_0}.
$$

Voltage standing-wave ratio:

$$
VSWR=\frac{1+|\Gamma|}{1-|\Gamma|}.
$$

The repository uses the report's mismatch-loss quantity

$$
RLR=-10\log_{10}\left(1-|\Gamma_{LOAD}|^2\right)\ \text{dB},
$$

which directly expresses the power penalty caused by mismatch.

With finite-$Q$ components, the matching network introduces insertion loss. Using the first-order component-loss model,

$$
IL=10\log_{10}\left(
1+\frac{G_{LOSS,PAR}}{G_{LOAD}}+
\frac{R_{LOSS,SER}}{R_{REF}}
\right),
$$

where

$$
G_{LOSS,PAR}=\frac{|B_{L,PAR}|+|B_{C,PAR}|}{Q_e},
$$

and

$$
R_{LOSS,SER}=\frac{|X_{L,SER}|+|X_{C,SER}|}{Q_e}.
$$

The net improvement is

$$
\boxed{G=RLR-IL}.
$$

A positive $G$ means the reduction in mismatch loss is larger than the insertion loss introduced by the tunable network.

---

## 4. Adaptive-Control Interpretation

The physical architecture is based on two independent loops:

$$
\boxed{
C_{PAR}\rightarrow R_{MATCH},
\qquad
C_{SERIES}\rightarrow X_{MATCH}
}
$$

The series branch is monotonic and is naturally suited to sign-based Up/Down control. The parallel branch contains two possible operating sides, so a secondary sign criterion based on the detected reactance is required to force the control trajectory into the stable region.

The original hardware-oriented concept can therefore be summarized as

$$
\text{RF voltage/current sensing}
\rightarrow \text{quadrature detection}
\rightarrow \operatorname{sign}(E)
\rightarrow \text{Up/Down counter}
\rightarrow \text{switched-capacitor array}.
$$

`simulate_aim_tracking.m` is a **digital-twin visualization**, not a transistor-level reproduction of the mixed-signal controller. It uses the analytical target capacitances and discrete capacitor steps to make the impedance trajectory visible on a Smith chart.

---

## 5. Benchmark Load Cases

The six benchmark antenna conditions are

| Case | $Z_{LOAD}$ |
|---|---:|
| A | $50+j0\ \Omega$ |
| B | $200+j0\ \Omega$ |
| C | $50+j75\ \Omega$ |
| D | $50-j75\ \Omega$ |
| E | $25+j50\ \Omega$ |
| F | $25-j50\ \Omega$ |

The included scripts reproduce the analytical capacitor values and the finite-$Q$ IL / gain values for both 900 and 1800 MHz.

---

## 6. Visualizations

The repository contains four visualization layers.

### A. A–F performance summary

For each operating band, plot

- VSWR before and after matching,
- $C_{PAR}$ and $C_{SERIES}$,
- insertion loss $IL$,
- net improvement gain $G$.

Run:

```matlab
plot_case_summary(900e6, true)
plot_case_summary(1800e6, true)
```

![900 MHz benchmark preview](pics/sim/case_summary_900MHz.png)

![1800 MHz benchmark preview](pics/sim/case_summary_1800MHz.png)

### B. Phase-of-$\Gamma_{LOAD}$ sweep

This directly addresses the phase-sensitivity view used in the IEEE paper. The code sweeps

$$
\angle\Gamma_{LOAD}\in[-180^\circ,180^\circ]
$$

for a selected VSWR circle and plots

- $IL$ versus phase,
- $G$ versus phase,
- required $C_{PAR}$ and $C_{SERIES}$ versus phase,
- infeasible regions caused by capacitor limits.

Run:

```matlab
plot_phase_sweep(900e6, 4.3, true)
```

![Phase sweep at 900 MHz](pics/sim/phase_sweep_900MHz.png)

### C. Smith-chart matching trajectory

The most intuitive visualization in this repository is analogous to a UAV trajectory-tracking animation: the starting point is the mismatched antenna impedance and the goal is the 50-Ω center of the Smith chart.

Run:

```matlab
p = aim_constants();
cases = aim_load_cases();
h = simulate_aim_tracking(900e6, cases(5).Z, p, 5e-12, 5e-12, 0.05e-12);
animate_smith_tracking(h, true);
```

This generates a GIF in `pics/sim/` when saving is enabled.

### D. Full benchmark regeneration

```matlab
run('scripts/generate_all_figures.m')
```

---

## 7. Repository Structure

```text
.
├── docs/
│   ├── 01_system_overview.md
│   ├── 02_l_network_model.md
│   ├── 03_evaluation_metrics.md
│   ├── 04_adaptive_control_architecture.md
│   ├── 05_tuning_region_design.md
│   ├── 06_simulation_results.md
│   ├── 07_visualization_guide.md
│   └── 08_github_publish.md
│
├── pics/
│   ├── sim/
│   │   ├── case_summary_900MHz.png
│   │   ├── case_summary_1800MHz.png
│   │   ├── phase_sweep_900MHz.png
│   │   ├── phase_sweep_1800MHz.png
│   │   └── smith_tracking_case_E_900MHz.gif
│   └── README.md
│
├── results/
│   └── benchmark_results.csv
│
├── scripts/
│   ├── reproduce_benchmark_table.m
│   ├── demo_case_E_900MHz.m
│   └── generate_all_figures.m
│
├── srcs/
│   ├── MAIN_AIM_LNetwork.m
│   ├── aim_constants.m
│   ├── aim_load_cases.m
│   ├── aim_closed_form.m
│   ├── aim_network_response.m
│   ├── aim_case_summary.m
│   ├── aim_quantize_cap.m
│   ├── simulate_aim_tracking.m
│   ├── animate_smith_tracking.m
│   ├── plot_case_summary.m
│   ├── plot_phase_sweep.m
│   ├── plot_smith_grid.m
│   ├── z_to_gamma.m
│   └── gamma_to_z.m
│
├── tests/
│   └── validate_reference_cases.m
│
├── references/
│   └── README.md
├── .gitignore
├── LICENSE
└── README.md
```

---

## 8. Quick Start

MATLAB R2021b or newer is recommended. The core analytical model does **not** require RF Toolbox.

```matlab
cd('Adaptive-Impedance-Matching-L-Network')
addpath('srcs')
run('srcs/MAIN_AIM_LNetwork.m')
```

The scripts use standard MATLAB plotting and table functions. GIF creation uses `getframe`, `frame2im`, `rgb2ind`, and `imwrite`.

---

## 9. Key Idea

$$
\boxed{
\text{Mismatch}
\rightarrow \text{detect }(R,X)
\rightarrow \text{tune }C_{PAR}
\rightarrow \text{tune }C_{SERIES}
\rightarrow 50+j0\ \Omega
}
$$

The repository is deliberately organized like the author's UAV repositories: a short top-level technical narrative, detailed derivations in `docs/`, implementation in `srcs/`, and visual outputs in `pics/`.

---

## 10. References

[1] A. van Bezooijen, M. A. de Jongh, F. van Straten, R. Mahmoudi, and A. H. M. van Roermund, “Adaptive Impedance-Matching Techniques for Controlling L Networks,” *IEEE Transactions on Circuits and Systems I: Regular Papers*, vol. 57, no. 2, pp. 495–505, Feb. 2010. DOI: 10.1109/TCSI.2009.2023764.

[2] HCMUT Microwave Engineering course project, “Analysis and Tuning of L-Network Impedance Matching Under Antenna Impedance Variations Using Adaptive Control Techniques,” Group 06, 2026.

---

## Attribution / Public-Repository Note

The IEEE article itself is **not bundled** in this repository. Keep the DOI/reference above rather than redistributing the publisher PDF.

The original group report is also not bundled by default. A public repository should avoid exposing other students' personal information; this repo instead contains a condensed technical reconstruction in Markdown.

---

## 11. Publish to GitHub

A compact publishing checklist, suggested repository description, topics, and `git` commands are provided in [`docs/08_github_publish.md`](docs/08_github_publish.md).

