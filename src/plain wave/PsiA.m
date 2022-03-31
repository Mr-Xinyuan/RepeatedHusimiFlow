function res = PsiA(k, Axis, r0, sigma, isShow)
    %
    %   complex plane wave: psi = e^{ik\cdot{r}}
    %   k:  wavevector
    %   Axis:  Axis(1) -> x;
    %          Axis(2) -> y;
    %   sigma: uncertainty parameter
    %   isShow: figure out
    %

    [X, Y] = meshgrid(Axis{1}, Axis{2});

    res = exp((k(1) .* X + k(2) .* Y) * 1i);

    if (isShow)
        figure;

        surf(real(res));

        view(2);
        shading interp;
        axis([r0(1) - sigma, r0(1) + sigma r0(2) - sigma, r0(2) + sigma]);

        %   --------------save setting-------------------
        %
        %set(gca, 'xtick', [1 max(Axis(1))]);
        %set(gca, 'ytick', [1 max(Axis(2))]);

        %set(gca, 'FontSize', 25)

        % figure size and position
        %set(gcf, 'unit', 'centimeters', 'position', [0 0 10 10]);

        % filename and format
        %saveas(gcf, ['../figure/PsiA' num2str(1 / sigma * 50) '.png'], 'png');
    end

end
