function z = slice_function_along_plane(fun, cntr, width, nknots, do_plot, varargin)
z = zeros(nknots);

if numel(width) == 1
    width = [width, width; -width, -width];
elseif numel(width) ~= 4
    error('Uknown range par-s');
end

orthogonalize = false;
if nargin == 5
    vec1 = rand(size(cntr));
    vec1 = vec1 / sqrt(sum(vec1.^2));
    orthogonalize = true;
end
if nargin == 6
    vec1 = varargin{1};
    orthogonalize = true;
end
if nargin == 7
    vec1 = varargin{1};
    vec2 = varargin{2};
end

if orthogonalize 
    vec2 = rand(size(vec1));
    idx = ceil(rand()*numel(vec1));
    idxs = setdiff(1 : numel(vec1), idx);
    vec2(idx) = - sum(vec1(idxs) .* vec2(idxs)) / vec1(idx);
    vec2 = vec2 / sqrt(sum(vec2.^2)) * sqrt(sum(vec1.^2));
end
    
si = linspace(width(1,1), width(2,1), nknots);
sj = linspace(width(1,2), width(2,2), nknots);
for i = 1 : nknots
    for j = 1 : nknots
        z(i, j) = fun(cntr + si(i) * vec1 + sj(j) * vec2);
    end
end

if do_plot
    imagesc(z); colorbar;
end