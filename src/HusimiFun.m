%--------------------------------------
%Husimi function
%<psi|r0,k0,sigma>=(1/sigma/sqrt(pi/2))*I
%psi(r)*exp(-(r-r0)^2/4/sigma/sigma)*exp(i*k0*r)
%k0*abs(<psi|r0,k0,sigma>)^2
function res = HusimiFun(r0, k0, sigma, psi, x, y)
    n = length(x);
    m = length(y);
    tmp = zeros(m, n);

    for index1 = 1:m
       for index2 = 1:n
            tmp(index1, index2) = conj(psi(index1,index2))*exp(-((x(index2)-r0(1))^2+(y(index1)-r0(2))^2)/4/sigma/sigma)*exp((k0(1)*x(index2)+k0(2)*y(index1))*1i);
       end
    end
    
    res = sum(sum(tmp(2:m-1,2:n-1)))*4;
    res = res + sum(sum(tmp(2:m-1, 1)))*2;
    res = res + sum(sum(tmp(1, 2:n-1)))*2;
    res = res + sum(sum(tmp(2:m-1, n)))*2;
    res = res + sum(sum(tmp(m, 2:n-1)))*2;
    res = res + tmp(1,1) + tmp(1,n) + tmp(m,1) + tmp(m,n); 
    res = res*(x(n)-x(1))*(y(m)-y(1))/4/m/n;
    %%
    res = 2*abs(res)^2/sigma/sigma/pi;
end