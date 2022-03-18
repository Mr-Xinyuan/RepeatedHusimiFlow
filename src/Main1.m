%quiverœÚ¡ø
%clear all; clc;

N = 32;         % the number of test wavevector 
Nx = 200;       % x-axis Lattice sites
Ny = 200;       % y-axis Lattice sites
PisType = 'A';  % the type of wave packet 
delta_k = 0.3;  % momentum uncertainty

r0 = [0, 0];    % position
sigma = 1/delta_k;
%---------------------------------%
%the template of k, |k|=1
k = zeros(2, N);
theta = linspace(2*pi/N, 2*pi, N);
k(1, :) = cos(theta);
k(2, :) = sin(theta);
clear theta

%figure
%quiver(zeros(N, 1), zeros(1, N), k(1,:), k(2,:), 'k');
%axis off;
%------------------------------PsiA-------------------------------------%
if(PisType=="A")
        k0 = [1, 1];
        k0 = k0./norm(k0); 

        [Psi, x, y] = PsiA(k0, sigma, Nx, Ny, "off");

        v = HusimiVec(k, Psi, r0, sigma, x, y);
end
%------------------------------PsiB--------------------------------------%
if(PisType == "B")
        k0 = [1, 1];
        k0 = k0./norm(k0); 

        [Psi, x, y] = PsiB(k0, sigma, Nx, Ny, "off");

        v = HusimiVec(k, Psi, r0, sigma, x, y);
end
%-----------------------------PsiC-------------------------------------%
if(PisType == "C")
        k1 = [1, 1];
        k2 = [-1, 1];
        k1 = k1./norm(k1);
        k2 = k2./norm(k2); 

        [Psi, x, y] = PsiC(k1, k2, sigma, Nx, Ny, "off");

        v = HusimiVec(k, Psi, r0, sigma, x, y);
end
%plot the Husimi vector%

PlotHusimiMap(r0, v, k);