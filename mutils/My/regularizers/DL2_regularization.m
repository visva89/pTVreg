function [f, grad] = DL2_regularization(Knots, kspc, D)
    gvol = prod(kspc);
    nd = numel(kspc);
    k = 1;
    ksz = size(Knots(:,:,:, 1));
    Nd = size(Knots, 4);

    f = 0;
    grad = zeros(size(Knots));
    for nn = 1 : size(Knots, 5)
        for i = 1 : Nd
            tmp = D * fl(Knots(:,:,:, i, nn));
            f = f + sum(tmp(:).^2 );
            grad(:,:,:, i, nn) = grad(:,:,:, i, nn) + reshape(D' * fl(tmp), ksz);
        end
    end
    f = f * gvol / 2;
    grad = grad * gvol;
end