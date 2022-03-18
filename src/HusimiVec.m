function v = HusimiVec(k, psi, r0, sigma, x, y)
    n = length(k);
    v = zeros(n, 1);
    
    for index = 1:n

        v(index) = HusimiFun(r0, k(:, index), sigma, psi, x, y);
    
    end

    %normal vector
    v = v./max(v);
end