function v = HusimiVec(varargin)
    %   ----------------------------------------------------------------
    %   Husimi projection.
    %   produces a Husumi vector.
    %   v = HusimiVec(k, psi, r0, sigma)
    %   v = HusimiVec(k, psi, r0, sigma, A)
    %
    n = length(varargin{1});
    v = zeros(n, 1);

    switch nargin
        case 4
            % Traversal
            for index = 1:n

                v(index) = HusimiFun(varargin{3}, varargin{1}(index, :), varargin{4}, varargin{2});

            end

        case 5
            % * in magnetic
            % Traversal
            for index = 1:n

                v(index) = HusimiFun(varargin{3}, varargin{1}(index, :), varargin{4}, varargin{2}, varargin{5}/2);

            end
    end

end
