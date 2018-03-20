function g = numerical_grad(f, x, dx, idxs)
    x0 = x;
    fx0 = double(f(x0));
    g = x * 0;
    if isempty(idxs)
        idxs = 1 : numel(x);
    end
%     idxs = 1:numel(x);
%     idxs = randperm(numel(x));
    for i = idxs
%         i/numel(x)
        x = x0;
        x(i) = x(i) - dx;
        fx = double(f(x));
        g(i) = (fx0 - fx) / dx;
    end
end