%quiverœÚ¡ø
clear all;clc;
alpha = 1;
beta = 0.8;
sigma = 1/0.5;
Nx = 100;
Ny = 100;
Psi_c = zeros(Nx, Ny);

x = linspace(-10, 10, Nx);
y = linspace(-10, 10, Ny);
[X, Y] = meshgrid(x,y);
k1 = [1,1];
k2 = [-1,1];

k1 = k1./norm(k1);
k2 = k2./norm(k2);

Psi_c = alpha*cos(k1(1)*X+k1(2)*Y);%+beta*cos(k2(1)*X+k2(2)*Y);
%Psi_c = exp(-(k1(1)*X+k1(2)*Y)*1i);
%surf(X, Y, real(Psi_c));
%shading interp 
%view(2)


k0 = [0,0];
r0 = [0,0];
figure;
index = 1;
for theta = 0:pi/16:2*pi
        k0(1) = cos(theta);
        k0(2) = sin(theta);
        res = HusimiFun(r0, k0, sigma, Psi_c, x, y);
        quiver(r0(1),r0(2),res*k0(1),res*k0(2));
        index = index + 1;
        %disp(res); 
end
