%clear all; clc;
sigma = 1/0.3;
M = 32;
N = 32;
Nx = 100;
Ny = 100;
r0 = [0, 0];
%---------------------------------%
% the template k
% k -> k_j
k = zeros(2, N);
theta = linspace(2*pi/N, 2*pi, N);
k(1, :) = cos(theta);
k(2, :) = sin(theta);
clear theta
%--------------------------------%
% the template k_test
% k_test -> k_i_test
theta = linspace(pi/M, 2*pi, M);

k_test = zeros(2, M);
k_test(1, :) = cos(theta);
k_test(2, :) = sin(theta);

clear theta
%--------------------------------------------------------------------%
%
%    Psi_c = alpha*cos(k1(1)*X+k1(2)*Y)+beta*cos(k2(1)*X+k2(2)*Y)
%
%-------------------------------------------------------------------%
k1 = [1, 1];
k2 = [-1, 1];
k1 = k1./norm(k1);
k2 = k2./norm(k2); 

[Psi, x, y] = PsiC(k1, k2, sigma, Nx, Ny, "off");

v = HusimiVec(k, Psi, r0, sigma, x, y); 
%--------------------------------------------------------------------%
clear k1 k2
%--------------------------------------------------------------------%
%
%                       MMA算法的实现
%
%--------------------------------------------------------------------%
[d, k_s, v_new] = MMA(v, k_test, k, r0, sigma, Nx, Ny);

%plot the Husimi vector%
%figure
%hold on;
%for index = 1:N
%        quiver(r0(1), r0(2), u(index,1), u(index, 2), 'k', 'LineWidth', 1);
%end
%hold off;
d = d.*5;
PlotHusimiMap(r0, v_new, N);
hold on;
for index_test = 1:M
    quiver(r0(1), r0(2), d(index_test).*k_s(1,index_test), d(index_test).*k_s(2,index_test), 'r', 'LineWidth', 2 ,'maxheadsize', 1);
end
%axis([-0.8,0.8 -0.8,0.8]);

set(gca,'FontSize',25)
    set(gcf,'unit','centimeters','position',[0 0 12 10]);
    saveas(gcf, ['../figure/Hu' PisType  '.png'], 'png');%num2str(delta_k*100) '.png'], 'png');
