function [ds, k_test] = ProcHusimiMap(varargin)
    % HusimiMap - Description
    %
    % Syntax:  ds, k_test = ProcHusimiMap(R, v, k0, Grid, E_level, sigma, Type, V)
    %
    % Long description                  
    % Radius: system's radius           1
    % v: Husimi vector                  2
    % k0: test wavevector template      3
    % Grid: sample points set           4
    % E_level: energy level             5
    % sigma: uncertainty                6
    % Type: well, harmonic, magnetic    7
    % V:    0 in well (no parameter) ------------------>8
    %       V0 in harmonic potential ($V=V0*r^2$)
    %       B in magnetic potential (magnetic field strength)
    addpath('../utilities');
    narginchk(7, 8);

    % test wavevector <- plain wave templates
    M = 32;
    theta = linspace(2 * pi / M, 2 * pi, M);
    k_test = [cos(theta)', sin(theta)'];
    clear theta;

    % Husimi function of plain wave
    [N, lenGrid] = size(varargin{2});
    u = zeros(N, M);

    % plot processed Husimi Map
    tic;

    switch varargin{7}
            %%
        case 'well'
            % dispersion relation:
            % $k=\sqrt{E}$
            % k_test = k_test * sqrt(varargin{5});

            for index = 1:M

                u(:, index) = exp(-2 * varargin{6}^2 * varargin{5}*((k_test(index, 1) - varargin{3}(:, 1)).^2 + (k_test(index, 2) -  varargin{3}(:, 2)).^2));

            end

            figure;
            hold on;

            for index = 1:lenGrid
                [ds, k_s] = MMA(varargin{2}(:, index), u, k_test*sqrt(varargin{5}));
                PlotProHusimiMap(ds, varargin{6} * k_s, varargin{4}(index, :));
            end

            hold off;
            %%
        case 'harmonic'
            % dispersion relation:
            % k^2 = sqrt(E-V*(x^2+y^2))
            k_2 = @(x, y)(varargin{5} - varargin{8} * (x * x + y * y));

            figure;
            hold on;
            for index = 1:lenGrid

                % dispersion relation:
                % $k=\sqrt{E}$
                var_x = varargin{4}(index, 2) - varargin{1};
                var_y = varargin{4}(index, 1) - varargin{1};

                for u_index = 1:M

                    u(:, u_index) = exp(-2 * varargin{6}^2 *k_2(var_x, var_y)* ((k_test(u_index, 1) - varargin{3}(:, 1)).^2 + (k_test(u_index, 2) - varargin{3}(:, 2)).^2));

                end

                [ds, k_s] = MMA(varargin{2}(:, index), u, k_test*sqrt(k_2(var_x, var_y)));
                PlotProHusimiMap(ds, varargin{6} * k_s, varargin{4}(index, :));
            end

            hold off;
            %%
        case 'magnetic'
            % dispersion relation:
            % $k=\sqrt{E}$
%             k_test = k_test * sqrt(varargin{5});

            for index = 1:M

                u(:, index) = exp(-2 * varargin{6}^2 * varargin{5}*((k_test(index, 1) - varargin{3}(:, 1)).^2 + (k_test(index, 2) -  varargin{3}(:, 2)).^2));

            end

            figure;
            hold on;

            for index = 1:lenGrid
                [ds, k_s] = MMA(varargin{2}(:, index), u, k_test * sqrt(varargin{5}));
                PlotProHusimiMap(ds, varargin{6} * k_s, varargin{4}(index, :));
            end

            hold off;
    end

    toc;
    % ------------------- plot boundary ---------------
    % x1 = (0,2R)
    % (x1-R)^2 + (y1-R)^2 = R^2
    PlotBoundary(varargin{1});
end
