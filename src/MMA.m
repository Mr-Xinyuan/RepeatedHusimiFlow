function [d_stored, k_test_stored, v] = MMA(v, k_test, k, r0, sigma, Nx, Ny)
    eps = 0.15;
    
    M = length(k_test(1, :));
    k_test_stored = zeros(2, M);
    d_stored = zeros(1, M);
    %N = length(v(1, :));
    
    for index_test = 1:M
        [Psi_test, x1, y1] = PsiTest(k_test(:, index_test), sigma, Nx, Ny);
        u = HusimiVec(k, Psi_test, r0, sigma, x1, y1); 
        
        while true
            %
            %计算衡量标准d= v'*u_i
            d=v'*u;

            %找到最大值
            dm = max(max(d));
            [index_v, index_u] = find(d == dm);
            
            if dm < eps  
                break;
            end 
            
            v(:,index_v) = v(:,index_v) - dm./(norm(u(:,index_u)).^2).*u(:,index_u);

            %将小于零的值设为零
            v(v(:, index_v)<0, index_v) = 0; 
        end
        k_test_stored(:,index_test) = k_test(:,index_test);
        d_stored(index_test) = dm;
    end
end