function res = PlotHusimiMap(varargin)
%
%    PlotHusimiMap(r0, v, k)
%    PlotHusimiMap(r0, v, filename)
%    PlotHusimiMap(r0, v, filename, format)
%

    narginchk(3,5);
    %--------------------------------------------------------------------%
    %       Only Plot Husimi Map
    %
    %
    if nargin == 3
        v = varargin{2};
        k = varargin{3};
        r0 = varargin{1};

        figure;
        hold on;
        for index = 1:length(v)
            quiver(r0(1), r0(2), v(index)*k(1, index), v(index)*k(2, index),...
                    'k', ...                %   color
                    'LineWidth', 1.5, ...   %   line width
                    'maxheadsize', 0.5);    %   head size
        end
        hold off;
        axis([-1,1 -1,1]); 
        res = 0;
    %--------------------------------------------------------------------%
    %       Plot Husimi Map
    %       Save File's Name is the fourth parameter 
    %
    elseif nargin == 4
        v = varargin{2};
        k = varargin{3};
        r0 = varargin{1};
        filename = varargin{4};

        figure;
        hold on;
        for index = 1:length(v)
            quiver(r0(1), r0(2), v(index)*k(1, index), v(index)*k(2, index),...
                    'k', ...                %   color
                    'LineWidth', 1.5, ...   %   line width
                    'maxheadsize', 0.5);    %   head size
        end
        hold off;  
        axis([-1,1 -1,1]);
        res = 0;        
    %-------------------------------------------------------------------------%
    %
    %                               Save settings
    %
    %-------------------------------------------------------------------------%
        %axis off;
        set(gcf,'unit',...
            'centimeters','position', [0 0 12 10],...
            'FontSize', 25);
        saveas(gcf, ['../figure/Hu_' filename '.png'], 'png');
    %--------------------------------------------------------------------%
    %       Plot Husimi Map
    %       Save File's Name is the fourth parameter
    %       Save File's format is the fifth parameter
    elseif nargin == 5
        v = varargin{2};
        k = varargin{3};
        r0 = varargin{1};
        filename = varargin{4};
        format = varargin{5};

        figure;
        hold on;
        for index = 1:length(v)
            quiver(r0(1), r0(2), v(index)*k(1, index), v(index)*k(2, index),...
                    'k', ...                %   color
                    'LineWidth', 1.5, ...   %   line width
                    'maxheadsize', 0.5);    %   head size
        end
        hold off;  
        axis([-1,1 -1,1]);
        res = 0;        
    %-------------------------------------------------------------------------%
    %
    %                               Save settings
    %
    %-------------------------------------------------------------------------%
        %axis off;
        set(gcf,'unit',...
            'centimeters','position', [0 0 12 10],...
            'FontSize', 25);
        saveas(gcf, ['../figure/Hu' filename '.' format], format);
    else
        error('incorrect number of parameters')
    end
end