function [d_stored, k_test_stored, v] = MMA(v, k_test, k, r0, sigma, Nx, Ny)
%
%   r0: position
%   sigma: uncertainty
%
    eps = 0.1;

    M = length(k_test);
    k_test_stored = zeros(2, 1);
    d_stored = zeros(1, 1);

    %the set of templates is created 
    u = TestHusmiVec(M, k_test, k, r0, sigma, Nx, Ny);
    
    d_max = 1;
    index_test = 1;    
    while d_max > eps
        % dot(v,u_i)
        d = v'*u;

        [d_max, index_max] = max(d);

        % stored k_test and d
        k_test_stored(:, index_test) = k_test(:, index_max);
        d_stored(index_test) = d_max;

        % reset v
        v = v - d_max/(norm(u(:, index_max))^2).*u(:, index_max);

        % set zero
        v( v < 0 ) = 0;

        index_test = index_test + 1;
    end
end
%----------------------------------------------------%
%           Create the test Wave packet
%----------------------------------------------------%
function u = TestHusmiVec(M, k_test, k, r0, sigma, Nx, Ny)
    x = linspace(-sigma, sigma, Nx);
    y = linspace(-sigma, sigma, Ny);

    [X, Y] = meshgrid(x, y);
    
    N = length(k);
    %create the u_i
    u = zeros(N, M);
    for index = 1:M
        Psi_test = PsiTest(k_test(:, index), X, Y);
        u(:, index) = HusimiVec(k, Psi_test, r0, sigma, x, y); 
    end
end
% the test wave
function res = PsiTest(k, X, Y)

    res = exp((k(1)*X+k(2)*Y)*1i);

end