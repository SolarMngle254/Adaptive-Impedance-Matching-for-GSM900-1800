# 05 — Tuning-Region Design

A mathematically valid impedance transformation is not automatically physically realizable. The design must keep both capacitors positive and inside their hardware tuning range.

## Capacitor-ratio requirement

For ideal self-resonance with a fixed inductor,

$$
C=\frac{1}{\omega^2L}.
$$

For two operating frequencies $f_1$ and $f_2$,

$$
\frac{C_1}{C_2}=\left(\frac{f_2}{f_1}\right)^2.
$$

For 900 and 1800 MHz, the frequency ratio is 2, so the theoretical resonance-only capacitor ratio is 4.

The implemented 0.5–7.0 pF range provides a ratio of 14, leaving additional margin for severe antenna detuning rather than only frequency translation.

## Physical feasibility tests

The code checks three basic conditions:

1. the square-root argument used to compute $B_{INT}$ is non-negative;
2. $C_{PAR}$ is finite and lies inside the tunable range;
3. $C_{SERIES}$ is finite and lies inside the tunable range.

These checks make it straightforward to visualize the matchable and non-matchable regions in a phase sweep.

## Nominal inductor selection

The benchmark values are

$$
L_{PAR}=6\ \text{nH},
\qquad
L_{SERIES}=12\ \text{nH}.
$$

With the 0.5–7.0 pF capacitor range, these values reproduce the A–F dual-band solutions used in the report.
