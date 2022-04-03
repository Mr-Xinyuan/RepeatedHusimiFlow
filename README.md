# Repeated Husimi Map

As part of the undergraduate graduation project: repeat the results of the Husimi map.

## Directory Structure

    ├─data
    │  ├─circular system
    │  │  ├─harmonic
    │  │  ├─magnetic
    │  │  └─well
    │  └─stadium system
    ├─doc
    ├─images
    │  ├─circular system
    │  │  ├─harmonic
    │  │  ├─magnetic
    │  │  └─well
    │  ├─figure
    │  └─stadium system
    ├─src
    │  ├─circular system
    │  ├─MMA
    │  ├─plain wave
    │  ├─stadium system
    │  └─utilities
    └─test

- data: To save the calculated data
- doc: Related documentation
- images: To save the image(wave function, raw Husimi map, processed Husimi Map)
- src: Source code
- test: Related test code

## Theory and Concept

- **Husimi projection**
  $$
   \langle \psi|\mathbf{r}_0,\mathbf{k}_0,\sigma \rangle= \int\psi^{*}(\mathbf{r})\mathrm{e}^{-\frac{(\mathbf{r}-\mathbf{r}_0)^2}{4\sigma^2}+\mathrm{i}\mathbf{k}_0\cdot\mathbf{r}}\,\mathrm{d}\mathbf{r}
  $$

- **Huismi function**
  $$
    \mathrm{Hu}(\psi,\mathbf{r}_0,\mathbf{k}_0)=|\langle \psi|\mathbf{r}_0,\mathbf{k}_0,\sigma \rangle|^2
  $$

- **Huismi vector**: $\mathbf{v}_{Husimi}(\mathbf{r}_0) = \mathrm{Hu}(\psi,\mathbf{r}_0,\mathbf{k}_0)\mathbf{k}_{0}$
- **Husimi map**:$\{\mathbf{k}_{j}\}\rightarrow\{\mathbf{v}_{j}\}$

- **Hamiltonian Matrix**（Tightbinding Approximation Model）
    $$
    H = \sum_{i} \epsilon_{i}a_{i}^{\dagger}a_{i}-t\sum_{i,j}a_{i}^{\dagger}a_{j}
    $$
    where $\epsilon_{i}=4t+U_{i},t=\frac{\hbar^2}{2ma^2}$.If magnetic fields is added, it needs to use the *Peierls substitution*, i.e. $t_{i,j}=t\exp(i\phi),\phi=\frac{q}{\hbar}\mathbf{A}\cdot(\mathbf{r}_i-\mathbf{r}_j)$

- **Nondimensionalization**
  
  $a$ is the spacing between lattice points. With ***'*** is a dimensionless quantity
  - $x = x'a$
  - $k = \frac{k'}{a}$
  - $\Delta x = \sigma = \sigma'a$
  - $\Delta k = \frac{1}{2\sigma} = \frac{1}{2\sigma'a}$
  - $k = \frac{\sqrt{2mE}}{\hbar} = \sqrt{E'}\frac{\sqrt{2mt}}{\hbar} = \frac{\sqrt{E'}}{a}\rightarrow k'=\sqrt{E'}$
  - $V_0=V'_0\frac{a^2}{t}\rightarrow V(r)=V'_0\,r'^2\cdot t$ in harmonic potential.
  - $\mathbf{A'}=\frac{qaB_{0}}{2\hbar}(-y\mathbf{e}_{x}+x\mathbf{e}_{y})\rightarrow\mathbf{A'}=\frac{B'_{0}}{2}(-y'\mathbf{e}_{x}+x'\mathbf{e}_{y})$
  - $B_{0} = B'_{0}\frac{\hbar}{qa^2}$ in magnetic fields.

- **Magnetic Vector Potential** in **Symmetric Gauge**
  $$
  \mathbf{A}=-\frac{1}{2}(\mathbf{r}\times\mathbf{B})=\frac{B_0r}{2}\mathbf{e}_{\theta}=\frac{B_0}{2}(-y\mathbf{e}_x+x\mathbf{e}_y)
  $$

## Cautions

- There are protection mechanisms to prevent rendering too many images.
- Symmetric gauge are used instead of Landau gauge

## Reference

- [1] D. J. Mason, M. F. Borunda, and E. J. Heller. *Quantum flux and reverse engineering of quantum wave functions.* EPL (Europhysics Letters), 102(6):60005, 2013.
- [2] D. J. Mason, M. F. Borunda, and E. J. Heller. Revealing the flux: *Using processed husimi maps to visualize dynamics of bound systems and mesoscopic transport.* Physical Review B, 91(16):165405, 2015.
