%quiverœÚ¡ø
%clear all; clc;
delta_k = 0.02;
sigma = 1/delta_k;
N = 32;
Nx = 200;
Ny = 200;
r0 = [0, 0];
PisType = 'A';
%---------------------------------%
%the template of k
k = zeros(2, N);
theta = linspace(2*pi/N, 2*pi, N);
k(1, :) = cos(theta);
k(2, :) = sin(theta);
clear theta
%figure
%quiver(zeros(N, 1), zeros(1, N), k(1,:), k(2,:), 'k', 'LineWidth', 1.5);
%axis off;
%------------------------------PsiA-------------------------------------%
if(PisType=="A")
        k0 = [1, 1];
        k0 = k0./norm(k0); 

        [Psi, x, y] = PsiA(k0, sigma, Nx, Ny, "on");

        v = HusimiVec(k, Psi, r0, sigma, x, y);
end
%------------------------------PsiB--------------------------------------%
if(PisType == "B")
        k0 = [1, 1];
        k0 = k0./norm(k0); 

        [Psi, x, y] = PsiB(k0, sigma, Nx, Ny, "on");

        v = HusimiVec(k, Psi, r0, sigma, x, y);
end
%-----------------------------PsiC-------------------------------------%
if(PisType == "C")
        k1 = [1, 1];
        k2 = [-1, 1];
        k1 = k1./norm(k1);
        k2 = k2./norm(k2); 

        [Psi, x, y] = PsiC(k1, k2, sigma, Nx, Ny, "on");

        v = HusimiVec(k, Psi, r0, sigma, x, y);
end
%plot the Husimi vector%

PlotHusimiMap(r0, v, N, delta_k);