function [res, x, y] = PsiA(k, sigma, Nx, Ny, disp)

    x = linspace(-sigma, sigma, Nx);
    y = linspace(-sigma, sigma, Ny);
    [X, Y] = meshgrid(x,y);
    
    res = exp((k(1)*X+k(2)*Y)*1i);

    if(disp == "on")
        figure
        surf(X, Y, real(res));
        shading interp 
        view(2)

        xlim([-sigma, sigma]);
        ylim([-sigma, sigma]);
        set(gca,'xtick', [-floor(sigma) 0 floor(sigma)]);
        set(gca,'ytick', [-floor(sigma) 0 floor(sigma)]);
        %set(gca,'xtick', [-0.4 0 0.4]);
        %set(gca,'ytick', [-0.4 0 0.4]);
        set(gca,'FontSize',25)
        set(gcf,'unit','centimeters','position',[0 0 10 10]);
        filename = ['../figure/PsiA' num2str(1/sigma*100) '.png'];
        saveas(gcf, filename, 'png');
    end
end