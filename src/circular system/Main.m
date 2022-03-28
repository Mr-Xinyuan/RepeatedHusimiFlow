delta_k = 0.1;

%   -----------define sigma-----------
%
%       $ Sigma \propto k/\Delta{k} $
%       let k = 1
%
sigma = 0.5 / delta_k;
R = 50;

% [Listx, delta] = HarmonicOscillator(R, 0, {10, 1,10}, 'on');

% [Listx, delta] = CircularWell(70, {10, 1, 10}, 'on');
% pause

level = 197;
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
% [x,y] = WaveFunction(50, {1,1,1}, 'on', 'magnetic', 2e-3);
% [x,y] = WaveFunction(50, {1,1,1}, 'on', 'harmonic', 2e-3);
% [x,y] = WaveFunction(50, {1,1,1}, 'on', 'well');
% The discrete situation
% figure('visible', strIsShow);
% figure;
% plot(x,y,'.');