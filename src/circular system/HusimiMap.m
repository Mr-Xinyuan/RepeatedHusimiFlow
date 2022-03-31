function [k, v, Grid] = HusimiMap(varargin)
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
    narginchk(4, 5);

    % test wavevector {k_j}
    N = 32; %  N equally spaces points in k-space
    theta = linspace(2 * pi / N, 2 * pi, N);
    k = [cos(theta)', sin(theta)'];
    clear theta;

    % wave function Psi
    Psi = int8(0);
    load(['../../data/circular system/' varargin{4} '/data.mat'], 'Psi', 'x', 'y');
    meshPsi = sparse(x, y, Psi(:, varargin{2}));
    clear Psi;
    meshPsi = meshPsi./sqrt(sum(sum(abs(meshPsi).^2)));
    %     sigma = varargin{3} / k_level;

    % sample points
    rate = 2;
    Grid = MeshTestGrid(varargin{1}, varargin{3}, rate);
    PlotSamplePoints(x, y, Grid);
    clear x y;

    % calculate Husimi vector and plot Husimi map
    lenGrid = length(Grid);
    v = zeros(N, lenGrid);

    switch varargin{4}
        case 'well'
            % k = sqrt(E)
            % detail in README
            load(['../../data/circular system/' varargin{4} '/data.mat'], 'E');
            k_level = sqrt(E(varargin{2}));
            clear E ;
            
            tic;
            
            for index = 1:lenGrid
                % utilizing dispersion relation
                v(:, index) = HusimiVec(k* k_level, meshPsi, Grid(index, :), varargin{3});
            end

            toc;
            % plot Husimi Map
            v = v ./ max(max(v));
            figure;
            hold on;

            for index = 1:lenGrid
                PlotHusimiMap(Grid(index, :), v(:, index) * varargin{3} * rate, k);
            end

            hold off;

        case 'harmonic'
            % k = sqrt(E-V*(x^2+y^2))
            % detail in README
            load(['../../data/circular system/' varargin{4} '/data.mat'], 'E');
            E_level = E(varargin{2});
            clear E ;
            % calculate wavevector
            % calculate Husimi vector
            k_tmp = cell(lenGrid, 1);
            tic;

            for index = 1:lenGrid
                % utilizing dispersion relation
                x_tmp = Grid(index, 2) - varargin{1};
                y_tmp = Grid(index, 1) - varargin{1};
                k_tmp(index) = {k * sqrt(E_level - varargin{5} * (x_tmp * x_tmp + y_tmp * y_tmp))};
                v(:, index) = HusimiVec(k_tmp{index}, meshPsi, Grid(index, :), varargin{3});
            end

            clear x_tmp y_tmp k_tmp;
            % k = k_tmp;

            toc;
            tic;
            % plot Husimi Map
            v = v ./ max(max(v));
            figure;
            hold on;

            for index = 1:lenGrid
                PlotHusimiMap(Grid(index, :), v(:, index) * varargin{3} * rate, k);
            end

            hold off;
            toc;
        case 'magnetic'
            % k = sqrt(E))
            % detail in README
            load(['../../data/circular system/' varargin{4} '/data.mat'], 'E');
            E_level = sqrt(E(varargin{2}));
            clear E ;
            % calculate wavevector
            % calculate Husimi vector
            k_tmp = cell(lenGrid, 1);
            tic;

            for index = 1:lenGrid
                % utilizing dispersion relation
                x_tmp = Grid(index, 2) - varargin{1};
                y_tmp = Grid(index, 1) - varargin{1};
                k_tmp(index) = {k * sqrt(E_level - varargin{5} * (x_tmp * x_tmp + y_tmp * y_tmp))};
                v(:, index) = HusimiVec(k_tmp{index}, meshPsi, Grid(index, :), varargin{3});
            end

            clear x_tmp y_tmp k;
            k = k_tmp;

            toc;
            tic;
            % plot Husimi Map
            v = v ./ max(max(v));
            figure;
            hold on;

            for index = 1:lenGrid
                PlotHusimiMap(Grid(index, :), v(:, index) * varargin{3} * rate, k{index});
            end

            hold off;
            toc;
    end

    %     v = v ./ max(max(v));
    %     PlotHusimiMap(Grid, v * varargin{3} * rate, k);

    x1 = 0:0.1:2 * varargin{1};
    y1 = varargin{1} + sqrt(varargin{1}^2 - (x1 - varargin{1}).^2);
    hold on;
    plot(x1, y1, 'k');
    plot(x1, 2 * varargin{1} - y1, 'k');
    axis([1, max(x1) 1, max(y1)]);
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
    index = uint32(2);
    step = floor(rate * sigma);

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
