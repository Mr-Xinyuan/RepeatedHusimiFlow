delta_k = 0.1;

%   -----------define sigma-----------
%
%       $ Sigma \propto k/\Delta{k} $
%       let k = 1
%
sigma = 0.5 / delta_k;
% sigma = 1 / delta_k;
R = 65;

% [Listx, delta] = HarmonicOscillator(R, 0, {10, 1,10}, 'on');

% [Listx, delta] = CircularWell(70, {10, 1, 10}, 'on');
% pause

% level = 197;
% % level = [91, 84, 97];
% % for index = 1:3
% sigma = 0.5 / delta_k;
% [k, v, k_level, Grid, sigma] = HusimiMap(level, R, sigma, '../../data/HarmonicOscillator');
% hold on; 
% PlotBoundary(R);
% hold off;
% % save data.mat;
% % pause
% [ds, k_test] = ProcHusimiMap(v, k, k_level, Grid, sigma);
% hold on; 
% PlotBoundary(R);
% hold off;

% PlotSamplePoints(Grid);
% end
% WaveFunction(65, {200,1,200}, 'off', 'magnetic', 2e-3);
% WaveFunction(65, {300,200,300}, 'off', 'harmonic', 5e-5);
% [x,y] = WaveFunction(70, {20,15,20}, 'on', 'well');
% 197
[k, v, Grid]  = HusimiMap(65, 273, sigma, 'harmonic', 4e-4);
% [k, v, Grid]  = HusimiMap(65, 152, sigma, 'well');
% disp(sigma);
% The discrete situation
% figure('visible', strIsShow);
% figure;
% plot(x,y,'.');