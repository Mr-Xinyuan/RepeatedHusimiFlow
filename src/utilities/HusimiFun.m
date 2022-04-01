%--------------------------------------
% Husimi function
% <psi|r0,k0,sigma>=(1/sigma/sqrt(pi/2))*I
% psi(r)*exp(-(r-r0)^2/4/sigma/sigma)*exp(i*k0*r)
% k0*abs(<psi|r0,k0,sigma>)^2
function res = HusimiFun(r0, k0, sigma, psi)
    % ----------------------------------------------------
    %   name: Husimi function
    %   function: calculate Husimi projection.
    %   r0: test position (r0_x, r0_y)
    %   k0: test wavevector
    %   sigma: uncertainty parameter
    %   psi: wave function value
    %
    %   numerical integral algorithm: Trapezoidal method
    %
    [index1_range, index2_range] = GetIndexRange(size(psi), sigma, r0);

    % integration region;
    row_max = index1_range(2) - index1_range(1) + 1;
    col_max = index2_range(2) - index2_range(1) + 1;

    %   ------------------integral--------------------------
    tmp_i = 1;
    tmp_j = 1;
    tmp = zeros(row_max, col_max);

    % calculate integral
    sigma_width =- 0.25 / sigma / sigma;
    % numerical integral algorithm: Trapezoidal method
    %
    % index1: row and y
    % idnex2£ºcolumn and x
    for index1 = index1_range(1):index1_range(2)

        for index2 = index2_range(1):index2_range(2)

            % if psi(index1, index2) < 1e-7
            %     tmp_j = tmp_j + 1;
            %     continue;
            % end

            % --------- modify --------------
            % k01 = k0(1) +1e-3 * (index1 - 65);
            % k02 = k0(2) -1e-3 * (index2 - 65);
            %   integrand
            % tmp(tmp_i, tmp_j) = conj(psi(index1, index2))* ...
            %  exp(((index2 - r0(1))^2 + (index1 - r0(2))^2) * sigma_width)* ...
            %     exp((k01(1) * index2 + k02(2) * index1) * 1i);
            % -------------------------------
            %   integrand
            tmp(tmp_i, tmp_j) = conj(psi(index1, index2)) ...
            * exp(((index2 - r0(1))^2 + (index1 - r0(2))^2) * sigma_width) ...
                * exp((k0(1) * index2 + k0(2) * index1) * 1i);

            tmp_j = tmp_j + 1;

        end

        tmp_i = tmp_i + 1;
        tmp_j = 1;

    end

    res = sum(sum(tmp(2:row_max - 1, 2:col_max - 1)));
    res = res + sum(sum(tmp(2:row_max - 1, 1))) * 0.5;
    res = res + sum(sum(tmp(1, 2:col_max - 1))) * 0.5;
    res = res + sum(sum(tmp(2:row_max - 1, col_max))) * 0.5;
    res = res + sum(sum(tmp(row_max, 2:col_max - 1))) * 0.5;
    res = res + (tmp(1, 1) + tmp(1, col_max) + tmp(row_max, 1) + tmp(row_max, col_max)) * 0.25;
    % Hu = | res |^2
    res = abs(res)^2 / sigma / sigma / 6.283185; % 2*pi = 6.283185
end

function [index1, index2] = GetIndexRange(PsiSize, sigma, r0)

    index1 = zeros(2, 1);
    index2 = zeros(2, 1);

    %   three sigma principle: 3*sqrt(2)*sigma approximately 5*sigma
    index1(1) = r0(2) - floor(4.5 * sigma) + 1;
    index1(2) = r0(2) + floor(4.5 * sigma) + 1;
    index2(1) = r0(1) - floor(4.5 * sigma) + 1;
    index2(2) = r0(1) + floor(4.5 * sigma) + 1;

    % Whether cross-border
    if index1(1) <= 0
        index1(1) = 1;
    end

    if index2(1) <= 0
        index2(1) = 1;
    end

    if index1(2) > PsiSize(1)
        index1(2) = PsiSize(1);
    end

    if index2(2) > PsiSize(2)
        index2(2) = PsiSize(2);
    end

end
