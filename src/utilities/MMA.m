function [d_stored, k_test_stored] = MMA(varargin)
    %
    %   MMA(v, u, k_test)
    %   MMA(v, u, k_test, k)
    %   MMA(v, u, k_test, k, r0)
    %
    eps = 0.3; % threshold

    narginchk(3, 5);
    %   v: Husimi
    %   u: templates
    %   k_test: test plain wavevector
    %   k: test wavevector
    %   r0: test position
    v = varargin{1};
    u = varargin{2};
    k_test = varargin{3};

    k_test_stored = zeros(1, 2);
    d_stored = zeros(2, 1);

    if nargin == 4
        k = varargin{4};
        r0 = [1, 1];
    elseif nargin == 5
        k = varargin{4};
        r0 = varargin{5};
    end

    index_test = 1;

    while true
        % dot(v,u_i)
        d = v' * u;

        [d_max, index_max] = max(d);

        if d_max < eps
            break;
        end

        % stored k_test and d
        k_test_stored(index_test, :) = k_test(index_max, :);
        d_stored(index_test) = d_max;

        % reset v
        v = v - d_max / (norm(u(:, index_max))^2) .* u(:, index_max);

        % set zero
        v(v < 0) = 0;

        if nargin ~= 3
            figure;
            PlotHusimiMap(r0, v, k);
            hold on;

            for index = 1:index_test
                quiver(r0(1), r0(2), d_stored(index) * k_test_stored(index, 1), d_stored(index) * k_test_stored(index,2), ...
                    'r', ... %   color
                    'LineWidth', 2, ... %   line width
                    'maxheadsize', 0.25); %   head size

                axis([r0(1) - 2, r0(1) + 2 r0(2) - 2, r0(2) + 2]);
                % ---------save setting-------------
                %set(gca,'FontSize',25)
                %set(gcf,'unit','centimeters','position',[0 0 12 10]);
                %saveas(gcf, ['../figure/Hu' PisType  '.png'], 'png');
            end

            hold off
        end

        index_test = index_test + 1;
    end

end
