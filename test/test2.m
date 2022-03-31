    r=65;
    
    % vertical grid: Ny
    Ny = floor(r) - 1;
    % Horizontal grid: Nx
    Listx = zeros(2 * Ny + 1, 1);
    delta_r = r - floor(r);

    for index = 1:Ny
        d = r * sqrt(1 - (1 - (index + delta_r) / r )^2);
        Listx(index) = floor(d) * 2 + 1;
    end

    %Limit(2) = (Listx(index) - 1)*step_h/2;
    Listx(Ny + 1) = Listx(Ny);
    Listx(Ny + 2:2 * Ny + 1) = Listx(Ny:-1:1);
    Ny = 2*Ny + 1;

    N = sum(Listx);
    x = zeros(N, 1);
    y = zeros(N, 1);
    maxList = max(Listx);
    k = 1;
    for i = 1:Ny
        for j = 1:Listx(i)
            x(k) = (j - Listx(i) / 2 - 0.5) + r;
            y(k) = r - i - delta_r + r;
            k = k + 1;
        end
    end

    plot(x, y, '.');
    %axis([0,122 0,122]);
    x1 = 0:0.01:130;
    y1 = 65 + sqrt(65^2 - (x1 - 65).^2);
    hold on;
    plot(x1, y1 ,'r', 'LineWidth', 1.5);
    plot(x1, - y1 + 130 ,'r', 'LineWidth', 1.5);