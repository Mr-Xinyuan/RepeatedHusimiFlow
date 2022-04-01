function WaveFunction(varargin)
    % WaveFunction - calculating the value of wave function and Saving in the file.
    %
    % Syntax: WaveFunction(Radius, Level, strShow, Type)
    %         WaveFunction(Radius, Level, strShow, Type, V)
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

    if (varargin{2}{3} - varargin{2}{2} > 20) && (varargin{3} == "on")
        quit
    end

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
            saveas(gca, ['../../images/circular system/' varargin{4} '/' num2str(level) '_' num2str(E(level)) '.png'], 'png');
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
    % r = varargin{1};
    % Listx = varargin{2};
    % delta = varargin{3};
    % Allocate x and y memory space
    N = sum(varargin{2});
    x = zeros(N, 1);
    y = zeros(N, 1);
    disp(['grid count:' num2str(N)]);
    % In order to produce a sparse matrix
    index = int32(1);
    row_index = zeros(N, 1);
    col_index = zeros(N, 1);
    value_index = zeros(N, 1);

    % calculate H, x, y
    k = int32(1);
    down = int32(varargin{2}(1));
    Ny = int32(length(varargin{2}));

    % -----------------------------------------------------
    % model:
    %                    o (i-1,j)
    %                    |
    %       (i,j-1) o -- o -- o (i,j+1)
    %                    |
    %                    o (i+1,j)
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
                        down = -varargin{2}(i);
                    else
                        down = (varargin{2}(i + 1) - varargin{2}(i)) / 2;
                    end

                    %%
                    % Find the matrix element
                    for j = int32(1):varargin{2}(i)
                        % ------------calculate coordinate--------------------
                        x(k) = double(j - varargin{2}(i) / 2);
                        y(k) = double(varargin{1} - i - varargin{3});
                        % ------------calculate Hamilton matrix---------------
                        % ! difference
                        % H(k,k) = 4 + V(r);
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

                        if (j ~= varargin{2}(i))
                            % H(k, k+1) = -1;
                            row_index(index) = k;
                            col_index(index) = k + 1;
                            value_index(index) = -1;
                            index = index + 1;
                        end

                        if ((j + up) > 0) && (j <= (up + varargin{2}(i)))
                            % H(k, k - Listx(i) - up ) = -1;
                            row_index(index) = k;
                            col_index(index) = k - varargin{2}(i) - up;
                            value_index(index) = -1;
                            index = index + 1;
                        end

                        if ((j + down) > 0) && (j <= (down + varargin{2}(i)))
                            % H(k, k + Listx(i) + down) = -1;
                            row_index(index) = k;
                            col_index(index) = k + varargin{2}(i) + down;
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
                        down = -varargin{2}(i);
                    else
                        down = (varargin{2}(i + 1) - varargin{2}(i)) / 2;
                    end

                    %%
                    % Find the matrix element
                    for j = 1:varargin{2}(i)
                        % ------------calculate coordinate--------------------
                        x(k) = double(j - varargin{2}(i) / 2);
                        y(k) = double(varargin{1} - i - varargin{3});
                        % ------------calculate Hamilton matrix---------------
                        % H(k,k) = 4;
                        row_index(index) = k;
                        col_index(index) = k;
                        value_index(index) = 4;
                        index = index + 1;

                        % ! difference
                        if (j ~= 1)
                            % H(k, k-1) = -1;
                            row_index(index) = k;
                            col_index(index) = k - 1;
                            value_index(index) = -exp(- (parameter * y(k)) * 0.5i);
                            index = index + 1;
                        end

                        if (j ~= varargin{2}(i))
                            % H(k, k+1) = -1;
                            row_index(index) = k;
                            col_index(index) = k + 1;
                            value_index(index) = -exp((parameter * y(k)) * 0.5i);
                            index = index + 1;
                        end

                        if ((j + up) > 0) && (j <= (up + varargin{2}(i)))
                            % H(k, k - Listx(i) - up ) = -1;
                            row_index(index) = k;
                            col_index(index) = k - varargin{2}(i) - up;
                            value_index(index) = -exp(- (parameter * x(k)) * 0.5i);
                            index = index + 1;
                        end

                        if ((j + down) > 0) && (j <= (down + varargin{2}(i)))
                            % H(k, k + Listx(i) + down) = -1;
                            row_index(index) = k;
                            col_index(index) = k + varargin{2}(i) + down;
                            value_index(index) = -exp((parameter * x(k)) * 0.5i);
                            index = index + 1;
                        end

                        k = k + 1;
                    end

                end

        end

        x = x + varargin{1};
        y = y + varargin{1};
    else
        %%
        %well
        for i = int32(1):Ny
            up = -down;

            if (i == Ny)
                down = -varargin{2}(i);
            else
                down = (varargin{2}(i + 1) - varargin{2}(i)) / 2;
            end

            %%
            % Find the matrix element
            for j = int32(1):varargin{2}(i)
                % ------------calculate coordinate--------------------
                x(k) = double((j - varargin{2}(i) / 2) + varargin{1});
                y(k) = double(varargin{1} - i - varargin{3} + varargin{1});
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

                if (j ~= varargin{2}(i))
                    % H(k, k+1) = -1;
                    row_index(index) = k;
                    col_index(index) = k + 1;
                    value_index(index) = -1;
                    index = index + 1;
                end

                if ((j + up) > 0) && (j <= (up + varargin{2}(i)))
                    % H(k, k - Listx(i) - up ) = -1;
                    row_index(index) = k;
                    col_index(index) = k - varargin{2}(i) - up;
                    value_index(index) = -1;
                    index = index + 1;
                end

                if ((j + down) > 0) && (j <= (down + varargin{2}(i)))
                    % H(k, k + Listx(i) + down) = -1;
                    row_index(index) = k;
                    col_index(index) = k + varargin{2}(i) + down;
                    value_index(index) = -1;
                    index = index + 1;
                end

                k = k + 1;
            end

        end

    end

    H = sparse(row_index, col_index, value_index);
end
