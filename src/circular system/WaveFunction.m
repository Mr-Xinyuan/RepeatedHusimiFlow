function [x, y] = WaveFunction(varargin)
    % WaveFunction - calculating the value of wave function and Saving in the file.
    %
    % Syntax: x,y = WaveFunction(Radius, Level, strShow, Type)
    %         x,y = WaveFunction(Radius, Level, strShow, Type, V)
    %
    % algorithm: finite differential method.
    % model: tightbinding approximation.
    % Radius: system's radius
    % Level: the scope of level
    % Level{1}: level_max -> calculate the max level
    % Level{2}: level_begin
    % Level{3}: level_end
    % strShow: Show wave function figure
    % Type: well, harmonic, magnetic
    % V:    0 in well (no parameter)
    %       V0 in harmonic potential ($V=V0*r^2$)
    %       B in magnetic potential (magnetic field strength)
    narginchk(4, 5);
    % discrete circle boundary
    % [List, Delta] = MeshCircleArea(R);
    [List, Delta] = MeshCircleArea(varargin{1});

    % calculate the Hamilton matrix
    % [x, y, H] = HamiltonMatrix(R, List, Delta, Type, V);
    if nargin == 4
        [x, y, H] = HamiltonMatrix(varargin{1}, List, Delta);
    else
        [x, y, H] = HamiltonMatrix(varargin{1}, List, Delta, varargin{4}, varargin{5});
    end

    clear List Delta

    %   Psi: the value of wave function
    %   E: the level energy
    % [Psi, E] = eigs(H, level_max, 'sa');
    [Psi, E] = eigs(H, varargin{2}{1}, 'smallestabs');
    E = diag(E);
    clear H;

    %   ---------------------------------------------------------
    %   save the value of level energy and corresponding to wave function
    save (['../../data/circular system/' varargin{4} '/data.mat'], 'Psi', 'E', 'x', 'y');

    % figure wave function
    Limit = [1, max(x) 1, max(y)];

    % level = level_begin:level_end
    for level = varargin{2}{2}:varargin{2}{3}
        meshPsi = sparse(x, y, Psi(:, level));

        % ---------------figure wave function---------------
        %
        % figure('visible', strIsShow);
        figure('visible', varargin{3});

        % Calculate the modulus square of the wave function
        % plot the modulus square of the wave function
        surf(abs(meshPsi).^2);
        view(2);
        axis(Limit);
        shading interp;
        pbaspect([2 2 2]);

        %   --------------------save setting---------------------
        %
        % varargin{3} strIsShow
        if varargin{3} == "off"
            %set(gca, 'unit', 'centimeters', 'position', [0 0 15 15]);
            saveas(gca, ['../../images/circular system/' varargin{4} '/' num2str(level) '_' num2str(E(k, k)) '.png'], 'png');
        end

    end

end

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
    Listx = int32(zeros(2 * Ny + 1, 1));
    delta_r = r - floor(r);

    for index = 1:Ny
        d = r * sqrt(1 - (1 - (index + delta_r) / r)^2);
        Listx(index) = int32(floor(d) * 2 + 1);
    end

    Listx(Ny + 1) = Listx(Ny);
    Listx(Ny + 2:2 * Ny + 1) = Listx(Ny:-1:1);
end

function [x, y, H] = HamiltonMatrix(varargin)
    r = varargin{1};
    Listx = varargin{2};
    delta = varargin{3};
    % Allocate x and y memory space
    N = sum(Listx);
    x = zeros(N, 1);
    y = zeros(N, 1);

    % In order to produce a sparse matrix
    index = int32(1);
    row_index = zeros(N, 1);
    col_index = zeros(N, 1);
    value_index = zeros(N, 1);

    % calculate H, x, y
    k = int32(1);
    down = int32(Listx(1));
    Ny = int32(length(Listx));

    % -----------------------------------------------------
    % The difference between different row
    % up: i and i - 1
    % down: i and i + 1
    if nargin == 5
        parameter = varargin{5};

        switch varargin{4}
            case 'harmonic'
                % V = parameter*r^2
                %%
                for i = int32(1):Ny
                    up = -down;

                    if (i == Ny)
                        down = -Listx(i);
                    else
                        down = (Listx(i + 1) - Listx(i)) / 2;
                    end

                    %%
                    % Find the matrix element
                    for j = int32(1):Listx(i)
                        % ------------calculate coordinate--------------------
                        x(k) = double(j - Listx(i) / 2);
                        y(k) = double(r - i - delta);
                        % ------------calculate Hamilton matrix---------------
                        % H(k,k) = 4;
                        row_index(index) = k;
                        col_index(index) = k;
                        value_index(index) = 4 + parameter * (x(k) * x(k) + y(k) * y(k));
                        index = index + 1;

                        if (j ~= 1)
                            % H(k, k-1) = -1;
                            row_index(index) = k;
                            col_index(index) = k - 1;
                            value_index(index) = -1;
                            index = index + 1;
                        end

                        if (j ~= Listx(i))
                            % H(k, k+1) = -1;
                            row_index(index) = k;
                            col_index(index) = k + 1;
                            value_index(index) = -1;
                            index = index + 1;
                        end

                        if ((j + up) > 0) && (j <= (up + Listx(i)))
                            % H(k, k - Listx(i) - up ) = -1;
                            row_index(index) = k;
                            col_index(index) = k - Listx(i) - up;
                            value_index(index) = -1;
                            index = index + 1;
                        end

                        if ((j + down) > 0) && (j <= (down + Listx(i)))
                            % H(k, k + Listx(i) + down) = -1;
                            row_index(index) = k;
                            col_index(index) = k + Listx(i) + down;
                            value_index(index) = -1;
                            index = index + 1;
                        end

                        k = k + 1;
                    end

                end

            case 'magnetic'
                % A = ( -parameter*y, parameter*x, 0)
                %%
                for i = 1:Ny
                    up = -down;

                    if (i == Ny)
                        down = -Listx(i);
                    else
                        down = (Listx(i + 1) - Listx(i)) / 2;
                    end

                    %%
                    % Find the matrix element
                    for j = 1:Listx(i)
                        % ------------calculate coordinate--------------------
                        x(k) = double(j - Listx(i) / 2);
                        y(k) = double(r - i - delta);
                        % ------------calculate Hamilton matrix---------------
                        % H(k,k) = 4;
                        row_index(index) = k;
                        col_index(index) = k;
                        value_index(index) = 4;
                        index = index + 1;

                        if (j ~= 1)
                            % H(k, k-1) = -1;
                            row_index(index) = k;
                            col_index(index) = k - 1;
                            value_index(index) = -exp((parameter * y(k)) * 0.5i);
                            index = index + 1;
                        end

                        if (j ~= Listx(i))
                            % H(k, k+1) = -1;
                            row_index(index) = k;
                            col_index(index) = k + 1;
                            value_index(index) = -exp(- (parameter * y(k)) * 0.5i);
                            index = index + 1;
                        end

                        if ((j + up) > 0) && (j <= (up + Listx(i)))
                            % H(k, k - Listx(i) - up ) = -1;
                            row_index(index) = k;
                            col_index(index) = k - Listx(i) - up;
                            value_index(index) = -exp(- (parameter * x(k)) * 0.5i);
                            index = index + 1;
                        end

                        if ((j + down) > 0) && (j <= (down + Listx(i)))
                            % H(k, k + Listx(i) + down) = -1;
                            row_index(index) = k;
                            col_index(index) = k + Listx(i) + down;
                            value_index(index) = -exp((parameter * x(k)) * 0.5i);
                            index = index + 1;
                        end

                        k = k + 1;
                    end

                end

        end

        x = x + r;
        y = y + r;
    else
        %%
        %well
        for i = int32(1):Ny
            up = -down;

            if (i == Ny)
                down = -Listx(i);
            else
                down = (Listx(i + 1) - Listx(i)) / 2;
            end

            %%
            % Find the matrix element
            for j = int32(1):Listx(i)
                % ------------calculate coordinate--------------------
                x(k) = double((j - Listx(i) / 2) + r);
                y(k) = double(r - i - delta + r);
                % ------------calculate Hamilton matrix---------------
                % H(k,k) = 4;
                row_index(index) = k;
                col_index(index) = k;
                value_index(index) = 4;
                index = index + 1;

                if (j ~= 1)
                    % H(k, k-1) = -1;
                    row_index(index) = k;
                    col_index(index) = k - 1;
                    value_index(index) = -1;
                    index = index + 1;
                end

                if (j ~= Listx(i))
                    % H(k, k+1) = -1;
                    row_index(index) = k;
                    col_index(index) = k + 1;
                    value_index(index) = -1;
                    index = index + 1;
                end

                if ((j + up) > 0) && (j <= (up + Listx(i)))
                    % H(k, k - Listx(i) - up ) = -1;
                    row_index(index) = k;
                    col_index(index) = k - Listx(i) - up;
                    value_index(index) = -1;
                    index = index + 1;
                end

                if ((j + down) > 0) && (j <= (down + Listx(i)))
                    % H(k, k + Listx(i) + down) = -1;
                    row_index(index) = k;
                    col_index(index) = k + Listx(i) + down;
                    value_index(index) = -1;
                    index = index + 1;
                end

                k = k + 1;
            end

        end

    end

    H = sparse(row_index, col_index, value_index);
end
