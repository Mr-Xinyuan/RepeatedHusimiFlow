[X, Y] = meshgrid(1:201, 1:201);

k=[1,1];
k=k./norm(k);

res = exp((k(1) .* X + k(2) .* Y) * 1i+1e-3*(50*Y-50*X)*1i);

figure;
surf(imag(res));
view(2);
shading interp;

figure;
surf(real(res));
view(2);
shading interp;

res = exp((k(1) .* X + k(2) .* Y) * 1i);

figure;
surf(imag(res));
view(2);
shading interp;

figure;
surf(real(res));
view(2);
shading interp;