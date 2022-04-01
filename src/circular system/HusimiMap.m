function [k0, v, Grid, E_level] = HusimiMap(varargin)
    % detail in README
    % HusimiMap - Description
    %
    % Syntax: k, v, Grid, E_level = HusimiMap(R, Level, sigma, Type, V)
    %
    % Long description
    % Radius: system's radius
    % Level: energy level
    % sigma: uncertainty
    % Type: well, harmonic, magnetic
    % V:    0 in well (no parameter)
    %       V0 in harmonic potential ($V=V0*r^2$)
    %       B in magnetic potential (magnetic field strength)
    addpath('../utilities');
    narginchk(4, 5);

    % test wavevector {k_j}
    % calculate wavevector
    N = 32; %  N equally spaces points in k-space
    theta = linspace(2 * pi / N, 2 * pi, N);
    k0 = [cos(theta)', sin(theta)'];
    clear theta;

    % wave function Psi
    Psi = int8(0); % var Psi;
    load(['../../data/circular system/' varargin{4} '/data.mat'], 'Psi', 'x', 'y');
    meshPsi = sparse(x, y, Psi(:, varargin{2}));
    % meshPsi = meshPsi ./ sqrt(sum(sum(abs(meshPsi).^2))); % norm(meshPsi)
    % meshPsi = meshPsi./max(max(meshPsi));
    clear Psi;

    %---- sample points -----
    internal = 1;
    % sigma: "-"
    % -o--o--o--o- ==> interal = 1;
    % mean: the interval between each point is 2*sigma
    % Grid = MeshTestGrid(R, sigma, internal);
    Grid = MeshTestGrid(varargin{1}, varargin{3}, internal);
    % figure sample points
    PlotSamplePoints(x, y, Grid);
    clear x y;

    % calculate Husimi vector and plot Husimi map
    lenGrid = length(Grid);
    v = zeros(N, lenGrid);

    load(['../../data/circular system/' varargin{4} '/data.mat'], 'E');
    E_level = E(varargin{2});
    clear E;
    % calculate Husimi vector
    switch varargin{4}
        case 'well'
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
                v(:, index) = HusimiVec(k0 * k, meshPsi, Grid(index, :), varargin{3});
            end

        case 'harmonic'
            % dispersion relation:
            % k = sqrt(E-V*(x^2+y^2))
            k = @(x, y)(sqrt(E_level - varargin{5} * (x * x + y * y)));

            tic;

            % calculate Husimi vector
            for index = 1:lenGrid
                % utilizing dispersion relation
                % k = k * sqrt(E_level - varargin{5} * (x * x + y * y));
                % the center: (R,R)
                var_x = Grid(index, 2) - varargin{1};
                var_y = Grid(index, 1) - varargin{1};
                v(:, index) = HusimiVec(k0 * k(var_x, var_y), meshPsi, Grid(index, :), varargin{3});
            end

            clear var_x var_y;

            toc;
        case 'magnetic'
            % dispersion relation:
            % k = sqrt(E)
            % k = @(x, y)(sqrt(E));
            k = sqrt(E_level);

            tic;
            
            for index = 1:lenGrid
                % utilizing dispersion relation
                % var_x = Grid(index, 1);
                % var_y = Grid(index, 2);
                % k0*k(var_x, var_y);
                 v(:, index) = HusimiVec(k0*k, meshPsi, Grid(index, :), varargin{3});         
            end

            clear x_tmp y_tmp k;

            toc;
    end

    % --------- plot Husimi Map ---------
    tic;
    % v.norm(): max(v) == 1;
    v = v ./ max(max(v));
    % plot Husimi Map
    figure;
    hold on;

    % Husimi vector scope: -sigma ~ sigma
    varargin{3} = varargin{3} * internal;

    for index = 1:lenGrid
        PlotHusimiMap(Grid(index, :), v(:, index) * varargin{3}, k0);
    end

    hold off;
    toc;

    % ------------------- plot boundary ---------------
    % x1 = (0,2R)
    % (x1-R)^2 + (y1-R)^2 = R^2
    PlotBoundary(varargin{1});
end

function Grid = MeshTestGrid(r, sigma, internal)
    %
    %   radius: r
    %   simga: distance
    %   internal: internal sigma
    %
    % -----------generate test position in circular boundary----------
    %
    index = uint32(2);
    step = floor(2 * internal * sigma);

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
