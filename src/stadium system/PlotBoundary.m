function PlotBoundary(R)
    % PlotBoundary - circular boundary
    % Syntax: PlotBoundary(R)
    %
    % stadium boundary
    % Radius: system's parameter
    x1 = 0:0.1:R;
    y1 = sqrt(R^2 - x1.^2) + R;

    x1 = [x1, linspace(R + 0.1, 3 * R - 0.1, floor(20 * R - 2)), x1 + 3 * R];
    y1 = [fliplr(y1), 2 * R * ones(1, floor(20 * R - 2)), y1];

    hold on;
    plot(x1, y1, 'k', 'LineWidth', 1);
    plot(x1, 2 * R - y1, 'k', 'LineWidth', 1);
    hold off;

    pbaspect([2 1 1]);
    axis([0 max(x1) 0, max(y1)]);
end
