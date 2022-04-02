# Husim流在圆形边界系统的应用

## 势阱（硬墙）

## 谐振子（软墙）

## 加磁场

- 磁矢势：$\mathbf{A}(\mathbf{r})= \frac{1}{2}B_{0}r\mathbf{e}_{\theta}$  (库仑规范$\nabla\cdot\mathbf{A}=0$)

- 磁场：$\mathbf{B}=\nabla\times\mathbf{A}=\left|\begin{array}{cccc}  \frac{1}{r}\mathbf{e}_{r}&\mathbf{e}_{\theta}&\mathbf{e}_{z}\\\frac{\partial}{\partial r}&\frac{\partial}{\partial \theta}&\frac{\partial}{\partial z} \\ 0 & \frac{1}{2}B_{0}r& 0\end{array}\right|=\frac{1}{2}B_{0}\mathbf{e}_{z}$

- 无量纲化:

  - $A=A'\frac{\hbar}{qa}\rightarrow \mathbf{A'}=\frac{B'_{0}r'}{2}\mathbf{e}_{\theta}$

  - $B = B'\frac{\hbar}{qa^2}\rightarrow\mathbf{B'}=\frac{1}{2}B'_{0}\mathbf{e}_{z}$

数值计算代入的$B'_{0}=2\times{10}^{-3}$，文中说需要将“$\mathrm{i}\mathbf{k}\cdot\mathbf{r}$”项中的动量项做正则变换，即
$$ \mathbf{p}\rightarrow\mathbf{p}-q\mathbf{A}
$$
这样做之后$\mathrm{i}(\mathbf{k}-q\mathbf{A})\cdot\mathbf{r}=\mathrm{i}\mathbf{k}\cdot\mathbf{r}-\mathrm{i}q\mathbf{A}\cdot\mathbf{r}=\mathrm{i}\mathbf{k}\cdot\mathbf{r}$（由于基矢$\mathbf{e}_{r}$与$\mathbf{e}_{\theta}$正交）。所以与无磁场下的Husimi函数表达形式一样。因此，被积函数代码为

```matlab
    tmp(tmp_i, tmp_j) = conj(psi(index1, index2)) ...
                    * exp(((index2 - r0(1))^2 + (index1 - r0(2))^2) * sigma_width) ...
                    * exp((k0(1) * index2 + k0(2) * index1) * 1i);

```
