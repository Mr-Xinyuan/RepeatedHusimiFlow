%clear all; clc;
addpath('../utilities');
%%
%   function:           plotting Husimi map in plane wave
%   nondimensionalize:  the Method in README.md
%

N = 32; % the number of test wavevector
M = 32; % the number of templates
Nx = 1:121; % x-axios
Ny = 1:121; % y-axios
delta_k = 0.3; % momentum uncertainty
isShow = true;

r0 = [55, 55]; % test position

%   -----------define sigma-----------
%
%       $ Sigma \propto k/\Delta{k} $
%       let k = 1
%
sigma = 0.5 / delta_k;

%%
%   -----------test wavevector--------------
% test wavevector: k
% k -> k_j
theta = linspace(2 * pi / N, 2 * pi, N);

k = [cos(theta)', sin(theta)'];

%   plotting test wavevectors.
%
%       figure;
%       quiver(r0(1) .* ones(N, 1), r0(1) .* ones(1, N), k(1, :), k(2, :), 'k');
%       axis off;

%   --------------templates-----------------
% the templates: k_test
% k_test -> k_i_test
theta = linspace(2 * pi / M, 2 * pi, M);

k_test = [cos(theta)', sin(theta)'];

%   plotting test wavevectors.
%
%       figure;
%       quiver(r0(1) .* ones(N, 1), r0(1) .* ones(1, N), k_test(1, :), k_test(2, :), 'k');
%       axis off;
%
clear theta;
%%
%--------------------------------------------------------------------%
%
%    Psi_c = alpha*cos(k1(1)*X+k1(2)*Y)+beta*cos(k2(1)*X+k2(2)*Y)
%
%-------------------------------------------------------------------%
k1 = [1, 1];
k2 = [-1, 1];
k1 = k1 ./ norm(k1);
k2 = k2 ./ norm(k2);

Psi = PsiC(k1, k2, {Nx, Ny}, r0, sigma, isShow);
v = HusimiVec(k, Psi, r0, sigma);
% normal Husimi vector
v = v ./ max(v);
%   --------------------------------------------------------------------
clear k1 k2

%   -----------------templates---------------------
% the set of templates is created
u = zeros(N, M);

for index = 1:M

    u(:, index) = exp(-2 * sigma^2 * ((k_test(index, 1) - k(:, 1)).^2 + (k_test(index, 2) - k(:, 2)).^2));

end

%--------------------------------------------------------------------%
%
%                     (Multi-Model analysis)MMA
%
%--------------------------------------------------------------------%
[d, k_s] = MMA(v, u, k_test, k, r0);

%plot MMA -> processed Husimi Map
figure;
PlotProHusimiMap(d, k_s, r0);
