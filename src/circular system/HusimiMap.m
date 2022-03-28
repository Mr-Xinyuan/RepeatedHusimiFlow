function [k, v, k_level, Grid] = HusimiMap(varargin)
    % HusimiMap - Description
    %
    % Syntax: [k, v, k_level, Grid, sigma]  = HusimiMap(R, Level, sigma, Type, V)
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

    load(strPath, 'E', 'Psi', 'x', 'y');

    % the wave function

    % k = sqrt(E)
    % detail in README
    k_level = full(sqrt(E(Level, Level)));
    clear E;

    % test wavevector
    N = 32;
    theta = linspace(2 * pi / N, 2 * pi, N);
    k = [cos(theta)', sin(theta)'];
    clear theta;

    % utilizing dispersion relation
    k = k * k_level;
    %     sigma = sigma / k_level;

    % test point
    rate = 2;
    Grid = MeshTestGrid(R, sigma, rate);
    % PlotSamplePoints(x,y,Grid);

    % calculate Husimi vector
    lenGrid = length(Grid);
    v = zeros(N, lenGrid);
    tic;

    for index = 1:lenGrid
        v(:, index) = HusimiVec(k, meshPsi, Grid(index, :), sigma);
    end

    toc;
    % plot Husimi Map
    tic;

    v = v ./ max(max(v));
    PlotHusimiMap(Grid, v * sigma * rate, k);

    toc;
    clear Psi;
    x1 = 0:0.1:2 * R;
    y1 = R + sqrt(R^2 - (x1 - R).^2);

    hold on;
    plot(x1, y1, 'k');
    plot(x1, 2 * R - y1, 'k');
    pbaspect([1 1 1]);
    hold off;
end

function Grid = MeshTestGrid(r, sigma, rate)
    %
    %   radius: r
    %   simga: distance
    %   rate: internal sigma
    %
    % -----------generate test position in circular boundary----------
    %
    r = uint16(r);
    index = uint16(2);
    step = uint16(floor(rate * sigma));

    % scope: 0 ~ 2r
    n = 2 * r;
    Grid(1, :) = [r, r];

    for i = step:step:n

        if i^2 < r^2
            Grid(index, :) = [r, r + i];
            Grid(index + 1, :) = [r, r - i];
            Grid(index + 2, :) = [r + i, r];
            Grid(index + 3, :) = [r - i, r];
            index = index + 4;
        end

    end

    for i = step:step:n

        for j = step:step:n

            if i^2 + j^2 < r^2
                Grid(index, :) = [r + j, r + i];
                Grid(index + 1, :) = [r - j, r + i];
                Grid(index + 2, :) = [r + j, r - i];
                Grid(index + 3, :) = [r - j, r - i];
                index = index + 4;
            end

        end

    end

end
