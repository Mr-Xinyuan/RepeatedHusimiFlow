function PlotSamplePoints(x, y, Grid)

    % load('../../data/CircularWell/coord.mat', 'x', 'y');

    % ---------- figure sample points -------------
    figure;
    % discretization grid
    plot(x, y, 'g.');
    hold on;
    % sampling point
    plot(Grid(:, 1), Grid(:, 2), 'r*', 'lineWidth', 1.5);
%     axis([0, max(x) + 1 0, max(y) + 1]);
%     pbaspect([1 1 1]);
    hold off;

end
