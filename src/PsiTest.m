function [res, x, y] = PsiTest(k, sigma, Nx, Ny)

    x = linspace(-sigma, sigma, Nx);
    y = linspace(-sigma, sigma, Ny);
    [X, Y] = meshgrid(x,y);
    
    res = exp((k(1)*X+k(2)*Y)*1i);

end