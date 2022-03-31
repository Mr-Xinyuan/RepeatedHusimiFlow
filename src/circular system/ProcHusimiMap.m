function [ds, k_test] = ProcHusimiMap(varargin)
    % HusimiMap - Description
    %
    % Syntax: [k, v, k_level, Grid, sigma]  = ProcHusimiMap(v, k, k_level, Grid, sigma)
    %
    % Long description
    % Radius: system's radius
    % Level: the scope of level
    % Level{1}: level_max -> calculate the max level
    % Level{2}: level_begin
    % Level{3}: level_end
    % strShow: Show wave function figure
    % Type: well, harmonic, magnetic
    % V:    0 in well (no parameter)
    %       V0 in harmonic potential ($V=V0*r^2$)
    %       B in magnetic potential (magnetic field strength)
    addpath('../utilities');
    M = 32;
    theta = linspace(2 * pi / M, 2 * pi, M);
    k_test = [cos(theta)', sin(theta)'];
    clear theta;
    
    [N, lenGrid] = size(v);
    k_test = k_test * k_level;
    u = zeros(N, M);

    for index = 1:M

        u(:, index) = exp(-2 * sigma^2 * ((k_test(index, 1) - k(:, 1)).^2 + (k_test(index, 2) - k(:, 2)).^2));

    end
    
    figure;
    hold on;
    for index = 1:lenGrid
        [ds, k_s] = MMA(v(:, index), u, k_test);
        PlotProHusimiMap(ds, sigma*k_s, Grid(index, :));
    end
    hold off;

end
