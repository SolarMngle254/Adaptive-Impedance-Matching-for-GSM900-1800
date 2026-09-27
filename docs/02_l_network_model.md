# 02 — L-Network Model

Let

$$
Y_{LOAD}=\frac{1}{Z_{LOAD}}=G_{LOAD}+jB_{LOAD}.
$$

The shunt branch contributes

$$
B_{COR,PAR}=\omega C_{PAR}-\frac{1}{\omega L_{PAR}},
$$

so

$$
Y_{INT}=G_{LOAD}+jB_{INT},
\qquad
B_{INT}=B_{LOAD}+B_{COR,PAR}.
$$

Therefore,

$$
Z_{INT}=\frac{1}{Y_{INT}}
=\frac{G_{LOAD}}{G_{LOAD}^2+B_{INT}^2}
-j\frac{B_{INT}}{G_{LOAD}^2+B_{INT}^2}.
$$

Hence

$$
R_{INT}=\frac{G_{LOAD}}{G_{LOAD}^2+B_{INT}^2},
$$

and

$$
X_{INT}=-\frac{B_{INT}}{G_{LOAD}^2+B_{INT}^2}.
$$

The first-loop condition is

$$
R_{INT}=R_{REF}.
$$

Solving gives

$$
B_{INT}=\pm\sqrt{\frac{G_{LOAD}}{R_{REF}}-G_{LOAD}^2}.
$$

This immediately shows an important tuning-region condition: the square-root argument must be non-negative.

The corresponding parallel capacitor is

$$
C_{PAR}=\frac{B_{INT}-B_{LOAD}+1/(\omega L_{PAR})}{\omega}.
$$

The series branch contributes

$$
X_{SERIES}=\omega L_{SERIES}-\frac{1}{\omega C_{SERIES}}.
$$

For a final target reactance $X_{REF}$,

$$
X_{INT}+X_{SERIES}=X_{REF},
$$

and therefore

$$
C_{SERIES}=\frac{1}{\omega(\omega L_{SERIES}+X_{INT}-X_{REF})}.
$$

## Two possible intermediate solutions

Because $R_{INT}$ depends on $B_{INT}^2$, two mathematical solutions are possible:

- $B_{INT}<0 \Rightarrow X_{INT}>0$: inductive intermediate impedance;
- $B_{INT}>0 \Rightarrow X_{INT}<0$: capacitive intermediate impedance.

The benchmark design uses the inductive intermediate solution at 900 MHz and the capacitive intermediate solution at 1800 MHz. This choice reproduces the reported A–F capacitor values.
