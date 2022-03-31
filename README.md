# 重复Husimi图的结果

## MMA算法

### 操作

1.
   - 每个模板$\mathbf{u}_i=[u_i^1\ u_i^1\ \cdots u_i^N]$，其中每个成员$u_i^j=\mathrm{Hu}(\psi^{test},\mathbf{k}_j)$
   - Husimi矢量$\mathbf{v}=[v^1\ v^1\ \cdots v^N]$，其中每个成员$v^j=\mathrm{Hu}(\psi,\mathbf{k}_j)$

   ```matlab
      k = zeros(2, N);
      theta = linspace(2*pi/N, 2*pi, N);

      k(1, :) = cos(theta);
      k(2, :) = sin(theta);

      v = HusimiVec(k, Psi, r0, sigma, x, y);
      u = TestHusmiVec(M, k_test, k, r0, sigma, Nx, Ny);
   ```

2.
   - $d_i = \mathbf{v}\cdot\mathbf{u}_i$
   - find $\ \max \{d_i\}$
   - $\max\{d_i\},\ \mathbf{k}_i^{test}$保存

   ```matlab
      d = v'*u;

      [d_max, index_max] = max(d);

      % stored k_test and d
      k_test_stored(:, index_test) = k_test(:, index_max);
      d_stored(index_test) = d_max;
   ```

3. $\mathbf{v}\rightarrow\mathbf{v}-\mathbf{u}_i\frac{d_i}{\mathbf{u}_i\cdot\mathbf{u}_i}$

   ```matlab
      v = v - d_max/(norm(u(:, index_max))^2).*u(:, index_max);
   ```

4.
   将$\mathbf{v}$中小于零的值设为零

   ```matlab
      v(v<0) = 0;
   ```

5. 重复1)-6) 直到$d_i<eps$

6. $\{d_i\mathbf{k}_i^{test}\}$就是Husimi流

### 结果

![avatar](/images/figure/b.png)
![avatar](/images/figure/c.png)
![avatar](/images/figure/d.png)
![avatar](/images/figure/e.png)

## 无量纲化

其中 a 是格点间距。带“ **'** ”是无量纲量

### 紧束缚近似

$$
    H = \sum_{i} \epsilon_{i}a_{i}^{\dagger}a_{i}-t\sum_{i,j}a_{i}^{\dagger}a_{j}
$$

其中$\epsilon_{i}=4t+U_{i},t=\frac{\hbar^2}{2ma^2}$。若存在磁场，则$t_{i,j}=t\mathrm{e}^{\mathrm{i}\frac{qa}{\hbar}\mathbf{A}\cdot(\mathbf{r'}_{i}-\mathbf{r'}_{j})}=t\mathrm{e}^{\mathrm{i}\mathbf{A'}\cdot(\mathbf{r'}_{i}-\mathbf{r'}_{j})}\qquad(\mathbf{A} = \mathbf{A'}\frac{\hbar}{qa})$

- $k = \frac{\sqrt{2mE}}{\hbar} = \sqrt{E'}\frac{\sqrt{2mt}}{\hbar} = \frac{\sqrt{E'}}{a}\rightarrow k'=\sqrt{E'}$
- $\mathbf{A'}=\frac{qaB_{0}}{2\hbar}(-y\mathbf{e}_{x}+x\mathbf{e}_{y})\rightarrow\mathbf{A'}=\frac{B'_{0}}{2}(-y'\mathbf{e}_{x}+x'\mathbf{e}_{y})$

- $B_{0} = B'_{0}\frac{\hbar}{qa^2}$

### 不确定度

- $x = x'a$

- $k = \frac{k'}{a}$

- $\Delta x = \sigma = \sigma'a$

- $\Delta k = \frac{1}{2\sigma} = \frac{1}{2\sigma'a}$

- $\frac{\Delta k}{k} = \frac{\frac{1}{2\sigma'a}}{\frac{k'}{a}} = \frac{0.5}{\sigma'k'}$如果取$k'=1$，则可得$\frac{\Delta k}{k}=\frac{0.5}{\sigma'}$或$\sigma'=\frac{0.5}{\Delta k/k}$
