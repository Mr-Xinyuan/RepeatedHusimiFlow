function [Listx, delta] = MagneticField(R, B, level)
%myFun - Description
%
% [Listx, delta] = MagneticField(R, B)
%
% A = (-y*B, x*B, 0)/2;

    % get the scope of level
    level_max = level{1}; % calculate the max level
    level_begin = level{2};
    level_end = level{3};

    % discrete circle boundary
    [Listx, delta] = MeshCircleArea(rlim);

    % calculate the Hamilton matrix
    [x, y, H] = HamiltonMatrix(rlim, V0, Listx, delta);

    % The discrete situation
    figure('visible', strIsShow);
    plot(x, y, '.');
    save('../../data/HarmonicOscillator/coord.mat', 'x', 'y');

    %   Psi: the value of wave function
    %   E: the level energy
    [Psi, E] = eigs(H, level_max, 'sa');
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
            saveas(gca, ['../../images/HarmonicOscillator/Psi/' num2str(level) '.png'], 'png');
            save (['../../data/HarmonicOscillator/Psi/' num2str(level) '.mat'], 'meshPsi');
        end

    end

    %   ---------------------------------------------------------
    %   save the value of level energy
    save '../../data/HarmonicOscillator/Energy.mat' E;
    
end