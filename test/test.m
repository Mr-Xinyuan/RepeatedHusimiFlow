r0 = [50, 50];

r_min = [1, 1];

x = 1:101;
y = 1:101;
[X, Y] = meshgrid(x, y);

h = 1;
sigma = 0.5/0.1;
disp(sigma);

k0 = [1, 1];
k0 = k0 / norm(k0);

psi = exp((k0(1) * X + k0(2) * Y)*1i);

clear X Y

theta = pi / 16:pi / 16:2 * pi;

k = zeros(2, 32);
k(1, :) = cos(theta);
k(2, :) = sin(theta);

u = zeros(32, 1);

for index = 1:32

    u(index) = HusimiFun(r0, k(:, index), sigma, psi);

    plot(theta(index), u(index), 'r*');
    hold on
end

% plot(theta, u,'r*');
disp(u);
