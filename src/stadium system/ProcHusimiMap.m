function ProcHusimiMap(R, v, k0, Grid, E_level, sigma)
    % HusimiMap - Description
    %
    % Syntax:  ProcHusimiMap(R, v, k0, Grid, E_level, sigma)
    %
    % Long description
    % Radius: system's parameter
    % v: Husimi vector
    % k0: test wavevector template
    % Grid: sample points set
    % E_level: energy level
    % sigma: uncertainty
    addpath('../utilities');

    % test wavevector <- plain wave templates
    M = 32;
    theta = linspace(2 * pi / M, 2 * pi, M);
    k_test = [cos(theta)', sin(theta)'];
    clear theta;

    % Husimi function of plain wave
    [N, lenGrid] = size(v);
    u = zeros(N, M);

    % plot processed Husimi Map
    tic;

    % dispersion relation:
    % $k=\sqrt{E}$
    % k_test = k_test * sqrt(E_level);

    for index = 1:M

        u(:, index) = exp(-2 * sigma^2 * E_level * ((k_test(index, 1) - k0(:, 1)).^2 + (k_test(index, 2) - k0(:, 2)).^2));

    end

    figure;
    hold on;

    for index = 1:lenGrid
        v_max = max(v);

        [ds, k_s] = MMA(v(:, index) ./ v_max, u, k_test);

        ds = ds * sigma * v_max ./ max(ds);
        PlotProHusimiMap(ds, sigma * k_s, Grid(index, :));
    end

    hold off;

    toc;
    % ------------------- plot boundary ---------------
    % x1 = (0,2R)
    % (x1-R)^2 + (y1-R)^2 = R^2
    PlotBoundary(R);
end
