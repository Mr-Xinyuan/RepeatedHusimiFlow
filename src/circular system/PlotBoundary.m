function PlotBoundary(R)
    % PlotBoundary - circular boundary
    % Syntax: PlotBoundary(R)
    %
    % circular boundary
    % R: radius

    x1 = 0:0.1:2 * R;
    y1 = R + sqrt(R^2 - (x1 - R).^2);
    
    hold on;
    plot(x1, y1, 'k');
    plot(x1, 2 * R - y1, 'k');
    hold off;
    
    pbaspect([1 1 1]);
    axis([0, max(x1) 0, max(y1)]);
end
