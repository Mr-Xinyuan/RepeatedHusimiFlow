%--------------------------------------
% Husimi function
% <psi|r0,k0,sigma>=(1/sigma/sqrt(pi/2))*I
% psi(r)*exp(-(r-r0)^2/4/sigma/sigma)*exp(i*k0*r)
% k0*abs(<psi|r0,k0,sigma>)^2
function res = HusimiFun(varargin)
    % ----------------------------------------------------
    %   name: Husimi function
    %   function: calculate Husimi projection.
    %   type: res = HusimiFun(r0, k0, sigma, psi)
    %   type: res = HusimiFun(r0, k0, sigma, psi, A) in magnetic
    %   r0: test position (r0_x, r0_y)
    %   k0: test wavevector
    %   sigma: uncertainty parameter
    %   psi: wave function value
    %
    %   numerical integral algorithm: Trapezoidal method
    %
    [index1_range, index2_range] = GetIndexRange(size(varargin{4}), varargin{3}, varargin{1});

    % integration region;
    row_max = index1_range(2) - index1_range(1) + 1;
    col_max = index2_range(2) - index2_range(1) + 1;

    %   ------------------integral--------------------------
    tmp_i = 1;
    tmp_j = 1;
    tmp = zeros(row_max, col_max);

    % calculate integral
    sigma_width =- 0.25 / varargin{3} / varargin{3};
    % numerical integral algorithm: Trapezoidal method
    %
    % index1: row and y
    % idnex2£ºcolumn and x
    switch nargin
        case 4

            for index1 = index1_range(1):index1_range(2)

                for index2 = index2_range(1):index2_range(2)

                    % * can't optimize calculate
                    % // if psi(index1, index2) < 1e-7
                    % //    tmp_j = tmp_j + 1;
                    % //    continue;
                    % // end

                    %   integrand
                    tmp(tmp_i, tmp_j) = conj(varargin{4}(index1, index2)) ...
                    * exp(((index2 - varargin{1}(1))^2 + (index1 - varargin{1}(2))^2) * sigma_width) ...
                        * exp((varargin{2}(1) * index2 + varargin{2}(2) * index1) * 1i);

                    tmp_j = tmp_j + 1;

                end

                tmp_i = tmp_i + 1;
                tmp_j = 1;

            end

        case 5

            for index1 = index1_range(1):index1_range(2)

                for index2 = index2_range(1):index2_range(2)

                    % * can't optimize calculate
                    % // if psi(index1, index2) < 1e-7
                    % //    tmp_j = tmp_j + 1;
                    % //    continue;
                    % // end

                    % ! modfiy Husimi Function in 'magnetic' Field
                    % symmetric gauge ==> A=B/2*(-y,x)
                    % in HusimiVec: B -> B/2
                    %   integrand
                    tmp(tmp_i, tmp_j) = conj(varargin{4}(index1, index2)) ...
                    * exp(((index2 - varargin{1}(1))^2 + (index1 - varargin{1}(2))^2) * sigma_width) ...
                        * exp((varargin{2}(1) * index2 + varargin{2}(2) * index1 + varargin{5} * (index1 * varargin{1}(1) - varargin{1}(2) * index2)) * 1i);

                    tmp_j = tmp_j + 1;

                end

                tmp_i = tmp_i + 1;
                tmp_j = 1;

            end

    end

    res = sum(sum(tmp(2:row_max - 1, 2:col_max - 1)));
    res = res + sum(sum(tmp(2:row_max - 1, 1))) * 0.5;
    res = res + sum(sum(tmp(1, 2:col_max - 1))) * 0.5;
    res = res + sum(sum(tmp(2:row_max - 1, col_max))) * 0.5;
    res = res + sum(sum(tmp(row_max, 2:col_max - 1))) * 0.5;
    res = res + (tmp(1, 1) + tmp(1, col_max) + tmp(row_max, 1) + tmp(row_max, col_max)) * 0.25;
    % Hu = | res |^2
    res = abs(res)^2 / varargin{3} / varargin{3} / 6.283185; % 2*pi = 6.283185
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
