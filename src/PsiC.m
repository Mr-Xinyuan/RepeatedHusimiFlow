function [res, x, y] = PsiC(k1, k2, sigma, Nx, Ny, disp)

    alpha = 1;
    beta = 0.8;

    x = linspace(-sigma/beta,sigma/beta, Nx);
    y = linspace(-sigma/beta, sigma/beta, Ny);
    [X, Y] = meshgrid(x,y);
    
    res = alpha*cos(k1(1)*X+k1(2)*Y)+beta*cos(k2(1)*X+k2(2)*Y);

    if(disp == "on")
        figure
        surf(X, Y, res);
        shading interp 
        view(2)

        axis([-sigma, sigma -sigma sigma]);
        set(gca,'xtick', [-3 0 3]);
        set(gca,'ytick', [-3 0 3]);
        set(gca,'FontSize',25)
        set(gcf,'unit','centimeters','position',[0 0 10 10]);
        filename = ['../figure/PsiC' num2str(1/sigma*100) '.png'];
        saveas(gcf, filename, 'png');
    end
end