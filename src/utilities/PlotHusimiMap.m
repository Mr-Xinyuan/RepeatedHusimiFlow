function PlotHusimiMap(varargin)
    %
    %    PlotHusimiMap(r0, v, k)
    %    PlotHusimiMap(r0, v, filename)
    %    PlotHusimiMap(r0, v, filename, format)
    %

    narginchk(3, 5);
    %   v: Husimi vector
    %   k: test wavevector
    %   r0: test position
    v = varargin{2};
    k = varargin{3};
    r0 = varargin{1};
    %   ----------------------------------------------------
    %               Only Plot Husimi Map
    %
    N = length(v);
    %         quiver(r0_tmp(:, 1), r0_tmp(:, 2), k_tmp(:, 1), k_tmp(:, 2), ...
    %             'k', ... %   color
    %             'LineWidth', 1.5, ... %   line width
    %             'maxheadsize', 0.5); %   head size
    quiver(r0(1) * ones(N, 1), r0(2) * ones(N, 1), k(:, 1) .* v, k(:, 2) .* v, 'k','ShowArrowHead', 'off') %   color

    %   is Saving ?
    if nargin == 3
        %   ----------------------------------------------------
        %               Only Plot Husimi Map
        %
        return;
    elseif nargin == 4
        %   -----------------------------------------------------------
        %       Plot Husimi Map
        %       Save File's Name is the fourth parameter
        %
        filename = varargin{4};
        format = 'png';
    elseif nargin == 5
        %--------------------------------------------------------------------%
        %       Plot Husimi Map
        %       Save File's Name is the fourth parameter
        %       Save File's format is the fifth parameter
        filename = varargin{4};
        format = varargin{5};
    else
        error('incorrect number of parameters')
    end

    %   ---------------------------------------------------------------------
    %
    %                               Save settings
    %
    %   ----------------------------------------------------------------------
    %axis off;
    set(gcf, 'unit', ...
    'centimeters', 'position', [0 0 12 10], ...
        'FontSize', 25);
    saveas(gcf, ['../../images/figure/Hu_' filename '.' format], format);

end
