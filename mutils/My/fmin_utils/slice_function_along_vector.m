function vals = slice_function_along_vector(fun, ctr, vec, width, nknots, do_plot)

if isempty(vec)
    vec = rand(size(ctr))*2 - 1;
    vec = vec / sqrt(sum(vec.^2));
end
if numel(width) == 1
    width = [-width, width];
end
s = linspace(width(1), width(2), nknots);
vals = zeros(size(s));

for i = 1 : nknots
    vals(i) = fun(ctr + s(i) * vec);
end

if do_plot
    plot(s, vals, 'rx-');
end