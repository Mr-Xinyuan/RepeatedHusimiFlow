function res = PlotHusimiMap(r0, v, N, delta_k)
    res = 0;
    PisType = 'A';

    figure
    hold on;
    for index = 1:N
            quiver(r0(1), r0(2), v(1, index), v(2, index), 'k', 'LineWidth', 1.5, 'maxheadsize', 0.5);
    end
    hold off;
    %axis off;
    axis([-1,1 -1,1]);
    %xlabel('x/x_{max}(%)');
    %ylabel('y/y_{max}(%)');
    set(gca,'FontSize',25)
    set(gcf,'unit','centimeters','position',[0 0 12 10]);
    saveas(gcf, ['../figure/Hu' PisType num2str(delta_k*100) '.png'], 'png');
end