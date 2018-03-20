function [X, vec, step] = min_function_along_random_subspace(fun, ctr, width, vec0, N)
if isempty(vec0)
    vec0 = rand(size(ctr))*2 - 1;
    vec0 = vec0 / sqrt(sum(vec0.^2));
end
Q = rand(numel(ctr), N);
Q(:, 1) = vec0;
for i = 2 : N
    v = Q(:, i);
    for j = 1 : i - 1
        Q(:, i) = Q(:, i) - (v' * Q(:, j)) * Q(:, j); 
    end
    Q(:, i) = Q(:, i) / sqrt(sum(Q(:, i).^2));
end

%%Check Gram matrix
% [m1, m2] = ndgrid(1:N);
% G = sum(Q(:, m1(:)) .*  Q(:, m2(:)), 1);
% G = reshape(G, [N, N]);

opts = optimset('TolX', 0.01, ...
                'MaxFunEvals', 30, 'Display', 'off');
min_fval = 0;
min_par = 0;
min_vec = 0;
for i = 1 : N
    vec = Q(:, i);
    foblin = @(x) fun(ctr + vec * x);
    [par, fval] = fminbnd(foblin, -width, width, opts);
    if i == 1 || fval < min_fval
        min_par = par;
        min_fval = fval;
        min_vec = vec;
    end
end


vec = min_vec;
step = min_par;
X = ctr + min_vec * min_par;
fprintf('%e %e\n', fun(ctr), fun(X));