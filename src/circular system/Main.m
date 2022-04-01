delta_k = 0.1; % momentum uncertainty
R = 65; % system radius
% Type: well, harmonic, magnetic
Type = 'well';
isWaveFun = 'on';
%   -----------define sigma-----------
%
%       $ Sigma \propto k/\Delta{k} $
%       let k = 1
%
sigma = 0.5 / delta_k;

if STRCMP(isWaveFun,'on')  
    % --------------- calculate wave function --------------------
    % setting parameter
    level_scope = {200,1,200};
    % ! if level_scope > 10, program enters protection status(quit) 
    isShow = 'off';
    % harmonic -> V0 = 5e-5;
    % magnetic -> B0 = 2e-3;
    para_Potential = 5e-5;

    % ------------------------------------------------------------
    if STRCMP(Type,'well')  
        
        WaveFunction(R, level_scope, isShow, Type);
        
    else

        WaveFunction(R, level_scope, isShow, Type, paraPotential);

    end

else
    % --------------- plot raw Husimi Map and processed Husimi map--------------------
    % setting parameter
    des_level = 152;
    % *harmonic -> V0 = 5e-5;
    % *magnetic -> B0 = 2e-3;
    para_Potential = 5e-5;

    % ---------------------------------------------------------------------
    if STRCMP(Type,'well')
        
        [k, v, Grid, E]  = HusimiMap(R, des_level, sigma, Type);
        ProcHusimiMap(R, v, k, Grid, E, sigma, Type);

    else
        % test magnetic:217 215 224 210 248 249 245 212

        [k, v, Grid, E]  = HusimiMap(R, des_level, sigma, Type, para_Potential);
        ProcHusimiMap(R, v, k, Grid, E, sigma, Type, para_Potential);
    
    end
end
