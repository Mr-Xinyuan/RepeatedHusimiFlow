function res = PsiC(k1, k2, N, r0, sigma, isShow)
    %
    %   complex plane wave: psi = e^{ik\cdot{r}}
    %   k1:  wavevector
    %   k2:  wavevector
    %   N:  N(1) -> x;
    %       N(2) -> y;
    %   sigma: uncertainty parameter
    %   isShow: figure out
    %
    alpha = 1;
    beta = 0.8;

    [X, Y] = meshgrid(N{1}, N{2});

    res = alpha * cos(k1(1) * X + k1(2) * Y) + beta * cos(k2(1) * X + k2(2) * Y);

    if (isShow)
        figure;

        surf(X, Y, res);

        view(2);
        shading interp;
        axis([r0(1) - sigma, r0(1) + sigma r0(2) - sigma, r0(2) + sigma]);

        %   --------------save setting-------------------
        %
        %set(gca, 'xtick', [1 max(N(1))]);
        %set(gca, 'ytick', [1 max(N(2))]);

        %set(gca, 'FontSize', 25)

        % figure size and position
        %set(gcf, 'unit', 'centimeters', 'position', [0 0 10 10]);

        % filename and format
        %saveas(gcf, ['../figure/PsiC' num2str(1 / sigma * 50) '.png'], 'png');
    end

end
