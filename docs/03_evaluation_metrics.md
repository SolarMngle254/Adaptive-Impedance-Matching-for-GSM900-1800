# 03 — Evaluation Metrics

## Reflection coefficient

$$
\Gamma=\frac{Z-Z_0}{Z+Z_0}.
$$

Perfect matching gives $\Gamma=0$.

## VSWR

$$
VSWR=\frac{1+|\Gamma|}{1-|\Gamma|}.
$$

This is used both to describe the original antenna mismatch and the residual mismatch after inserting the finite-Q matching network.

## Mismatch power loss (RLR)

The power delivered to a mismatched load is

$$
P_{LOAD}=P_{IN}(1-|\Gamma|^2).
$$

Define

$$
RLR=-10\log_{10}(1-|\Gamma_{LOAD}|^2).
$$

Then

$$
P_{LOAD,dB}=P_{IN,dB}-RLR.
$$

This makes before/after power bookkeeping convenient.

## Finite-Q insertion loss

For a component quality factor $Q_e$, the first-order loss terms used by the benchmark model are

$$
G_{LOSS,PAR}=\frac{|B_{L,PAR}|+|B_{C,PAR}|}{Q_e}
$$

and

$$
R_{LOSS,SER}=\frac{|X_{L,SER}|+|X_{C,SER}|}{Q_e}.
$$

The insertion loss is approximated by

$$
IL=10\log_{10}\left(1+\frac{G_{LOSS,PAR}}{G_{LOAD}}+\frac{R_{LOSS,SER}}{R_{REF}}\right).
$$

## Net improvement

The matching network is useful only when the mismatch reduction exceeds its own dissipative loss:

$$
\boxed{G=RLR-IL}.
$$

This is why Case A is an important sanity check: a perfectly matched antenna has no mismatch loss to recover, so adding a lossy matching network produces negative net gain.
