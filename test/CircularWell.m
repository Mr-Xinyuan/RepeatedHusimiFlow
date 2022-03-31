function [Listx, delta] = CircularWell(rlim, level, strIsShow)
    %CircularWell - Description
    %
    % Syntax: [res, r] = CircularWell(rlim, N, V)
    %
    % calculate the circular well in V potential
    
    % get the scope of level
    level_max = level{1}; % calculate the max level
    level_begin = level{2};
    level_end = level{3};

    % discrete circle boundary
    [Listx, delta] = MeshCircleArea(rlim);

    % calculate the Hamilton matrix
    [x, y, H] = HamiltonMatrix(rlim, Listx, delta);

    % The discrete situation
    figure('visible', strIsShow);
    plot(x, y, '.');
    % save('../../data/CircularWell/coord.mat', 'x', 'y');

    %   Psi: the value of wave function
    %   E: the level energy
    [Psi, E] = eigs(H, level_max, 'smallestabs');
    E = sparse(E);

    for level = level_begin:level_end
        % Calculate the modulus square of the wave function
        meshPsi = sparse(x, y, Psi(:, level));

        % ---------------figure wave function---------------
        %
        figure('visible', strIsShow);

        % plot the modulus square of the wave function
        surf(abs(meshPsi).^2);
        view(2);
        shading interp;
        pbaspect([1 1 1]);
        axis([1, max(x) 1, max(y)]);

        if strIsShow == "off"
            %   --------------------save setting---------------------
            %
            %set(gca, 'unit', 'centimeters', 'position', [0 0 15 15]);
            saveas(gca, ['../../images/CircularWell/Psi/' num2str(level) '.png'], 'png');
            save (['../../data/CircularWell/Psi/' num2str(level) '.mat'],'meshPsi');
        end

    end

    %   ---------------------------------------------------------
    %   save the value of level energy
    % save '../../data/CircularWell/Energy.mat' E;
end

function [x, y, H] = HamiltonMatrix(r, Listx, delta)

    % Allocate x and y memory space
    N = sum(Listx);
    disp(N);
    x = zeros(N, 1);
    y = zeros(N, 1);

    % In order to produce a sparse matrix
    index = 1;
    row_index = zeros(N, 1);
    col_index = zeros(N, 1);
    value_index = zeros(N, 1);

    % calculate H, x, y
    k = 1;
    down = Listx(1);
    Ny = length(Listx);

    for i = 1:Ny
        % -----------------------------------------------------
        % The difference between different row
        % up: i and i - 1
        % down: i and i + 1
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
            x(k) = (j - Listx(i) / 2 - 0.5) + r;
            y(k) = r - i - delta + r;
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

    H = sparse(row_index, col_index, value_index);
end
