# MMA算法

## 操作

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

## 结果

![avatar](/figure/b.png)
![avatar](/figure/c.png)
![avatar](/figure/d.png)
![avatar](/figure/e.png)