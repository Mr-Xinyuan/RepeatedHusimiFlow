function res = Circular(rlim, h)
%Circular - Description
%
% Syntax: [res, r] = Circular(rlim, N, V)
%
% calculate the circular well in V potential
    tic; 

    level_max = 550;
    level_begin = 1;
    level_end = 550;

    [Listx,  delta] = MeshEllipseArea(h, rlim);
    N = sum(Listx);
    disp(N);
    [x, y, H] = HamiltonMatrix(rlim, Listx, delta, h, N);

    figure
    plot(x,y,'.');

    [Psi, ~] = eigs(H, level_max, 'sa');

    Ny = length(Listx);
    Nx = Listx((Ny-1)/2);
    meshPsi = zeros(Ny, Nx);
    %psi = zeros(N, 1);
    for level = level_begin:level_end
        %psi(:,1) = abs(Psi(:,level)).^2;%real(Psi(:,level));
        %计算波函数对应的网格点的值
        k = 1;
        for i = Ny:-1:1
            for j = 1:Listx(i) 
                dj = (Listx((Ny-1)/2) - Listx(i))/2;
                meshPsi(i, dj + j) = abs(Psi(k,level)).^2;
                k = k + 1;
            end
        end
        clear k i j
        figure('visible', 'off');
        surf(meshPsi);
        pbaspect([1 1 1]);
        axis([1,Nx 1,Ny]);
        shading interp
        view(2)
        set(gcf,'unit','centimeters','position',[0 0 15 15]);
        saveas(gca,['../Psi/' num2str(level) '.png'], 'png');
    end
    toc;
    res = toc;
end

function [Listx, delta]=MeshEllipseArea(step_h, r)
%用于将圆边界离散
%%计算纵向的离散格数
    Ny = floor(r/step_h) + 1;
%%计算横向的离散格数，并输出Listx
    Listx = zeros(2*Ny - 1, 1);
    Limit(1) = step_h*(Ny - 1);
    delta = r - Limit(1);  
        
    if(delta==step_h)
        Listx(1) = 1;
        for index  = 2:Ny-1
            d = r*sqrt(1 - (1 - (index - 1)*step_h/r - delta/r)^2);
            Listx(index) = floor(d/step_h)*2 + 1;
        end
    else
        for index  = 1:Ny-1
            d = r*sqrt(1 - (1 - (index - 1)*step_h/r - delta/r)^2);
            Listx(index) = floor(d/step_h)*2 + 1;
        end
    end    
    %Limit(2) = (Listx(index) - 1)*step_h/2;
    Listx(Ny) =  Listx(Ny - 1);
    Listx(Ny+1:2*Ny-1) = Listx(Ny-1:-1:1);
    %Ny = 2*Ny - 1;
end


function  [x, y, H] = HamiltonMatrix(r, Listx, delta, h, N) 
    k = 1;
    x = zeros(N,1);
    y = zeros(N,1);
    
    index = 1;
    down = Listx(1);
    row_index = zeros(N, 1);
    col_index = zeros(N, 1);
    value_index = zeros(N, 1);
    Ny = length(Listx);
    for i = 1:Ny
        %计算不同行之间的差别
        %计算做坐标与k,与相邻行之间的指标差异（up，down）
        up = -down;
        if(i == Ny)
           down = -Listx(i);
        else
           down = (Listx(i+1) - Listx(i))/2;
        end
        %遍历每列，寻找出矩阵元与边界
        for j = 1:Listx(i)        
    %%
            x(k) = (j-Listx(i)/2-0.5)*h;
            y(k) = r - (i-1)*h - delta; 
    %算哈密顿矩阵元
            %H(k,k) = 4;
            row_index(index) = k;
            col_index(index) = k;
            value_index(index) = 4;
            index = index + 1;
            if (j ~= 1)
                %H(k,k-1) = -1;
                row_index(index) = k;
                col_index(index) = k - 1;
                value_index(index) = -1;
                index = index + 1;   
            end
            if (j ~= Listx(i))
                %H(k,k+1) = -1;
                row_index(index) = k;
                col_index(index) = k + 1;
                value_index(index) = -1;
                index = index + 1; 
            end
            if ((j + up) > 0) && (j <= (up + Listx(i)))
               %H(k,k - Listx(i) - up ) = -1;
               row_index(index) = k;
               col_index(index) = k - Listx(i) - up;
               value_index(index) = -1;
               index = index + 1;    
            end
            if ((j + down) > 0) && (j <= (down + Listx(i)))
               %H(k,k + Listx(i) + down) = -1;   
               row_index(index) = k;
               col_index(index) = k + Listx(i) + down;
               value_index(index) = -1;
               index = index + 1;
            end
    %记录边界点,同时在边界加上势垒
    %         if((j==1)||(j==Listx(i)))                
    %             H(k,k) = H(k,k) + 1000; 
    %         end
    %加入delta势函数
            k = k + 1; 
        end
    end

    H = sparse(row_index, col_index, value_index);
end
