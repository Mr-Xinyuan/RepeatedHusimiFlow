delta_k = 0.1; % momentum uncertainty
R = 40; % system radius
% Type: well, harmonic, magnetic
isWaveFun = 'on';
%   -----------define sigma-----------
%
%       $ Sigma \propto k/\Delta{k} $
%       let k = 1
%
sigma = 0.5 / delta_k;

%
if strcmp(isWaveFun, "on")
    % --------------- calculate wave function --------------------
    % setting parameter
    level_scope = {200, 1, 200};
    % ! if (level_scope > 10) & (isShow = 'on'), program enters protection status(quit)
    isShow = 'off';
    
    WaveFunction(R, level_scope, isShow);
else
    % --------------- plot raw Husimi Map and processed Husimi map--------------------
    % setting parameter
    des_level = 152;

    % * RAW HUSIMI MAP
    [k0, v, Grid, E_level] = HusimiMap(R, des_level, sigma);
    % * PROCESSED HUSIMI MAP
    ProcHusimiMap(R, v, k0, Grid, E_level, sigma);
end
