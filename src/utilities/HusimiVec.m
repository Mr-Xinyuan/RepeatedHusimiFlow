function v = HusimiVec(k, psi, r0, sigma)
    %   ----------------------------------------------------------------
    %   Husimi projection.
    %   produces a Husumi vector.
    %
    n = length(k);
    v = zeros(n, 1);

    % Traversal
    for index = 1:n

        v(index) = HusimiFun(r0, k(index, :), sigma, psi);

    end

end
