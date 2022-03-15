function v = HusimiVec(k, psi, r0, sigma, x, y)
    n = length(k(1,:));
    v = zeros(2, n);
    d = 0;
    
    for index = 1:n
        tmp = HusimiFun(r0, k(:, index), sigma, psi, x, y);
        
        v(:, index) = k(:, index)*tmp; 
        if(abs(tmp) > d) 
            d = abs(tmp); 
        end
    end
    %normal vector
    v = v./d;
end