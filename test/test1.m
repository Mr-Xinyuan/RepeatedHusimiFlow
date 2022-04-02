% Type = 'harmonic';
% Type = 'well';
Type = 'magnetic';
level = 233;

% load(['../data/circular system/' Type '/data.mat'], 'E');
% figure;
% stairs(E,'*-');

load(['../data/circular system/' Type '/data.mat'], 'Psi','x','y');
meshPsi = sparse(x, y, Psi(:, level));
% meshPsi(meshPsi==0)=NaN;
figure
surf(real(meshPsi));
axis([1,max(x), 1,max(y)]);
view(2);
shading interp;


% figure;
% contour(x, y, real(k));

% figure;
% contour(x,y,real(k));
