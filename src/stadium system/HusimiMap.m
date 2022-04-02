function [k0, v, Grid, E_level] = HusimiMap(R, Level, sigma)
    % HusimiMap - Description
    %
    % Syntax: k, v, Grid, E_level = HusimiMap(R, Level, sigma)
    %
    % Radius: system's parameter
    % Level: energy level
    % sigma: uncertainty
    addpath('../utilities');

    % * test wavevector {k_j}
    % calculate wavevector
    N = 32; % N equally spaces points in k-space
    theta = linspace(2 * pi / N, 2 * pi, N);
    k0 = [cos(theta)', sin(theta)'];
    clear theta;

    % * wave function Psi
    Psi = int8(0); % var Psi;
    load('../../data/stadium system/data.mat', 'Psi', 'x', 'y');
    meshPsi = sparse(y, x, Psi(:, Level));
    % //meshPsi = meshPsi ./ sqrt(sum(sum(abs(meshPsi).^2))); % norm(meshPsi)
    % //meshPsi = meshPsi./max(max(meshPsi));
    clear Psi;

    %---- sample points -----
    internal = 1;
    % sigma: "-"
    % -o--o--o--o- ==> interal = 1;
    % mean: the interval between each point is 2*sigma
    % Grid = MeshTestGrid(R, sigma, internal);
    % TODO
    Grid = MeshTestGrid(R, sigma, internal);
    % figure sample points
    PlotSamplePoints(x, y, Grid);
    clear x y;
    
    % calculate Husimi vector and plot Husimi map
    lenGrid = length(Grid);
    v = zeros(N, lenGrid);

    load('../../data/stadium system/data.mat', 'E');
    E_level = E(Level);
    clear E;

    % dispersion relation:
    % k = sqrt(E)
    k = sqrt(E_level);

    tic;

    % calculate Husimi vector
    for index = 1:lenGrid
        % utilizing dispersion relation
        % k = k * sqrt(E_level);
        % var_x = Grid(index, 1);
        % var_y = Grid(index, 2);
        % v(:, index) = HusimiVec(k0 * k(var_x, var_y), ...);
        v(:, index) = HusimiVec(k0 * k, meshPsi, Grid(index, :), sigma);
    end

    toc;

    % --------- plot Husimi Map ---------
    tic;
    % v.norm(): max(v) == 1;
    v = v ./ max(max(v));
    % plot Husimi Map
    figure;
    hold on;

    % Husimi vector scope: -sigma ~ sigma
    sigma = sigma * internal;

    for index = 1:lenGrid
        PlotHusimiMap(Grid(index, :), v(:, index) * sigma, k0);
    end

    hold off;
    toc;

    % ------------------- plot boundary ---------------
    % x1 = (0,2R)
    PlotBoundary(R);
end

function Grid = MeshTestGrid(r, sigma, internal)
    %
    %   r: system's parameter
    %   simga: distance
    %   internal: internal sigma
    %   Grid(:, 1) -> x;
    %   Grid(:, 2) -> y;
    %
    % -----------generate test position in circular boundary----------
    %
    index = uint32(2);
    step = floor(2 * internal * sigma);

    % scope: 0 ~ 2r
    Grid(1, :) = [2*r, r];

    % two origin
    
    % x axis
    for i = step:step:floor(2*r)

        if Inside(i, 0)
            Grid(index, :) = [2*r + i, r];
            Grid(index + 1, :) = [2*r - i, r];
            index = index + 2;
        end

    end
    
    % y axis
    for j = step:step:floor(r)
        
        if Inside(0, j)
            Grid(index, :) = [2*r, r + j];
            Grid(index + 1, :) = [2*r, r - j];
            index = index + 2;
        end

    end

    % otherwise
    for i = step:step:floor(r)

        for j = step:step:floor(2*r)

            if Inside(j, i)
                Grid(index, :) = [2*r + j, r + i];
                Grid(index + 1, :) = [2*r - j, r + i];
                Grid(index + 2, :) = [2*r + j, r - i];
                Grid(index + 3, :) = [2*r - j, r - i];
                index = index + 4;
            end

        end

    end

    % Judgment point inside
    function res = Inside(x, y)
        res = false;
        if x > r

            if (x - r)^2 + y^2 < r^2
                res = true;
            end

        else

            if y < r
                res = true;
            end

        end

    end

end
