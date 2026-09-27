# 08 — Publishing to GitHub

Recommended repository name:

```text
Adaptive-Impedance-Matching-L-Network
```

Suggested description:

> Adaptive impedance matching of a dual-band L-network for GSM900/1800, with analytical tuning, finite-Q evaluation, MATLAB phase sweeps, and Smith-chart convergence animation.

## Before publishing

Keep the repository focused on your technical implementation and condensed documentation.

- Do not upload the IEEE publisher PDF. Keep the DOI/reference in `references/README.md`.
- Do not upload the full group report to a public repository unless all co-authors are comfortable with the personal information it contains.
- Prefer the reconstructed Markdown notes in `docs/` and the reproducible MATLAB implementation in `srcs/`.

## Command-line workflow

Create an empty repository on GitHub first, then from the repository folder run:

```bash
git init
git add .
git commit -m "Initial AIM L-network digital twin"
git branch -M main
git remote add origin https://github.com/SolarMngle254/Adaptive-Impedance-Matching-L-Network.git
git push -u origin main
```

If the final GitHub repository has a different name, replace the remote URL accordingly.

## Suggested topics

```text
adaptive-impedance-matching
l-network
rf
microwave-engineering
smith-chart
matlab
gsm900
gsm1800
adaptive-control
impedance-matching
```

## Suggested first release

Tag the first stable public version after MATLAB validation:

```bash
git tag -a v1.0.0 -m "Initial reproducible AIM digital twin"
git push origin v1.0.0
```
