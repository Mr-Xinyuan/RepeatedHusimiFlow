%clear all; clc;
addpath('../utilities');
%%
%   function:           plotting Husimi map in plane wave
%   nondimensionalize:  the Method in README.md
%

N = 32; % the number of test wavevector
Nx = 1:121; % x-axios
Ny = 1:121; % y-axios
delta_k = 0.1; % momentum uncertainty
%-----------------------------------%
%      A: complex plane wave        %
%      B: cosine plane wave         %
%-----------------------------------%
PisType = 'A'; % the type of wave packet
isShow = true; % Show wave function

r0 = [60, 60]; % test position

%   -----------define sigma-----------
%
%       $ Sigma \propto k/\Delta{k} $
%       let k = 1
%
sigma = 0.5 / delta_k;

%   --------------------test wavevectors k--------------------
%
%   |k| = 1;
%   N equally spaced points in k-space;
%
theta = linspace(2 * pi / N, 2 * pi, N);
k = [cos(theta)', sin(theta)'];

clear theta
%   plotting test wavevectors.
%
%       figure;
%       quiver(r0(1) .* ones(N, 1), r0(1) .* ones(1, N), k(1, :), k(2, :), 'k');
%       axis off;

%%
% wavevector k0
k0 = [1, 1];
k0 = k0 ./ norm(k0);

%   search plain wave type
%------------------------------PsiA-------------------------------------
if (PisType == "A")

    Psi = PsiA(k0, {Nx, Ny}, r0, sigma, isShow);
    v = HusimiVec(k, Psi, r0, sigma);

end

%------------------------------PsiB--------------------------------------
if (PisType == "B")

    Psi = PsiB(k0, {Nx, Ny}, r0, sigma, isShow);
    v = HusimiVec(k, Psi, r0, sigma);

end

% normal vector
v = v ./ max(v);
% -----------plotting Husimi Map---------------
%
%   plotting the Husimi vector
%
figure;
PlotHusimiMap(r0, v, k);
% one Husimi vector
axis([r0(1) - 1, r0(1) + 1 r0(2) - 1, r0(2) + 1]);
