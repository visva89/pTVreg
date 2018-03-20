function [err, grad] = folding_regularization(Knots, kspc, deps)
    err = 0;
    grad = zeros(size(Knots), 'like', Knots);
    nd = size(Knots, 4);
    kspc = kspc(1:nd);
    gvol = prod(kspc);
%     deps = 0.02;
    for i = 1 : nd
        k = squeeze(Knots(:,:,:, i));
        GK = {};
        if nd == 3
            [GK{1}, GK{2}, GK{3}] = my_gradient(k, kspc);
        elseif nd == 2
            [GK{1}, GK{2}] = my_gradient(k, kspc);
        end
        tf = GK{i} + 1 + deps;
        tt = sign(tf);
        tidx = tt < 0;
        tt(~tidx) = 0;

        err = err +  gvol * sum(abs(tf(tidx)));
        grad(:,:,:, i) = gvol * my_gradient(tt, kspc, i, 1);
    end
end