# Source Code

Introduction to the source code.

## Plain wave

The analytic expression of Husimi function in plain wave is
$$
   \mathrm{Hu}(\mathbf{r}_0,\mathbf{k}_0,\sigma;\psi)=8\pi\sigma^2\mathrm{e}^{-2\sigma^2(\mathbf{k}_{A}-\mathbf{k}_0)^2}
$$

- A: complex plain wave.
- B: cosine plain wave.
  
## MMA(Multi-Model Analysis)

1. **Reparation**
   - Template: $\mathbf{u}_i=[u_i^1\ u_i^1\ \cdots u_i^N]$ and each member:$u_i^j=\mathrm{Hu}(\psi^{test},\mathbf{k}_j)$
   - Husimi vector: $\mathbf{v}=[v^1\ v^1\ \cdots v^N]$ and each member: $v^j=\mathrm{Hu}(\psi,\mathbf{k}_j)$

   ```matlab
      k = zeros(2, N);
      theta = linspace(2*pi/N, 2*pi, N);

      k(1, :) = cos(theta);
      k(2, :) = sin(theta);

      v = HusimiVec(k, Psi, r0, sigma, x, y);
      u = TestHusmiVec(M, k_test, k, r0, sigma, Nx, Ny);
   ```

2. **Convolution Layer**
   - $d_i = \mathbf{v}\cdot\mathbf{u}_i$

    ```matlab
      d = v'*u;
    ```
  
3. **Poling Layer**
   - find $\ \max \{d_i\}$
   - save $\max\{d_i\},\ \mathbf{k}_i^{test}$

   ```matlab
      [d_max, index_max] = max(d);

      % stored k_test and d
      k_test_stored(:, index_test) = k_test(:, index_max);
      d_stored(index_test) = d_max;
   ```

   - $\mathbf{v}\rightarrow\mathbf{v}-\mathbf{u}_i\frac{d_i}{\mathbf{u}_i\cdot\mathbf{u}_i}$

   ```matlab
      v = v - d_max/(norm(u(:, index_max))^2).*u(:, index_max);
   ```

4. **ReLU Layer**
   - RELU function $\rightarrow \max\{0,x\}$
   - To prevent nonlinear mapping and overfitting

   ```matlab
      v(v<0) = 0;
   ```

5. repeated 1)-4) until $d_i<eps$.

6. Husimi Flux: $\{d_i\mathbf{k}_i^{test}\}$

## **Circular System**

- well: the boundary is $\infty$.
- harmonic: adding harmonic potential.
- magnetic: adding magnetic fields in symmetric gauge.

## **Stadium System**

In order to calculate Husimi Map and wave functions in stadium area.

## file function

- **HusimiMap.m**: To calculate Husimi vector and plot raw Husimi Map.
- **ProcHusimiMap.m**: Utilized MMA to calculate processed Husimi vector and plot processed Husimi Map.
- **WaveFunction.m**:calculate wave function value and energy level.
- **MMA.m**: Design MMA algorithm.
- **HusimiFun.m**: calculated Husimi function value.
- **HusimiVec.m**: calculated Husimi function vector.
- **PlotHusimiMap.m**: To plot local raw Husimi map.
- **PlotProHusimiMap.m**: To plot local processed Husimi map.
- **PlotBoundary.m**: To plot the system boundary.
