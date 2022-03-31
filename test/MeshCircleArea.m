function [Listx, delta_r] = MeshCircleArea(r)
    %
    %   radius: r
    %   delta_r: r - floor(r)
    %   Listx: Horizontal grid
    %   length(Listx): vertical grid
    %
    % -----------discrete circle boundary----------
    %
    % vertical grid: Ny
    Ny = floor(r) - 1;
    % Horizontal grid: Nx
    Listx = zeros(2 * Ny + 1, 1);
    delta_r = r - floor(r);

    for index = 1:Ny
        d = sqrt(r^2 - (r - index + delta_r)^2);
        Listx(index) = floor(d) * 2 + 1;
    end

    %Limit(2) = (Listx(index) - 1)*step_h/2;
    Listx(Ny + 1) = Listx(Ny);
    Listx(Ny + 2:2 * Ny + 1) = Listx(Ny:-1:1);
    %Ny = 2*Ny - 1;
end
