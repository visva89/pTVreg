function [f, grad] = DL1c_regularization(Knots, kspc, D, csqrt)
    gvol = prod(kspc);
    k = 1;
    ksz = size(Knots(:,:,:, 1));
    Nd = size(Knots, 4);
    f = 0;
    grad = zeros(size(Knots));
    p = 1;
%     p = 0.85;
    
    for nn = 1 : size(Knots, 5)
        for i = 1 : Nd
            tmp = D * fl(Knots(:,:,:, i, nn));
        
            t2 = sqrt(tmp(:).^2 + csqrt);
            f = f + sum(t2.^p);
            
%             grad = D' * ((abs(tmp)+deps).^(p-1) .* sign(tmp)) * p;
            
%             gr = D' * fl(tmp ./ t2);
            gr = D' * (tmp .* (t2.^(p-2)) * p);
            
            grad(:,:,:, i, nn) = grad(:,:,:, i, nn) + reshape(gr, ksz);
        end
    end
    f = f * gvol;
    grad = grad * gvol;
end