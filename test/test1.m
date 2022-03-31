Type = 'harmonic';
% Type = 'well';
% Type = 'magnetic';
level = 42;

load(['../data/circular system/' Type '/data.mat'], 'E');
figure;
stairs(E,'*-');

R = 65;
V0 = 5e-5;
E = E(level);
x =zeros(65*65*3, 1);
y =zeros(65*65*3, 1);

index = 1;
for i = 1:2*R-1
   for j = 1:2*R-1
       if (i-R)^2+(j-R)^2<R^2
            x(index) = i;
            y(index) = j;
            index = index + 1;
       end
   end 
end

k = sqrt(E-V0*((x-R).^2+(y-R).^2));

k = sparse(x, y, k);


% figure;
% contour(x, y, real(k));
figure;
contour(real(k));
shading interp;
axis([1,max(x) 1,max(y)]);

figure;
contour(imag(k));
shading interp;
axis([1,max(x) 1,max(y)]);

% figure;
% contour(x,y,real(k));
