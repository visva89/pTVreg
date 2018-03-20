function [f, grad] = temporal_DLp_regularization(Knots, kspc, D, p, deps)

%         cvol = prod(pix_resolution .* grid_spacing);
        cvol = prod(kspc);
        ksz = size(Knots);
        
        Kr = reshape(Knots, [ksz(1)*ksz(2)*ksz(3)*ksz(4), ksz(5)]);
        Kr = Kr';
        tmp = D * Kr;
%         f = sum(fl((abs(tmp)+deps).^p)) * cvol;
%         grad = D' * ((abs(tmp)+deps).^(p-1) .* sign(tmp)) * p;
%         grad = reshape(grad', size(Knots)) * cvol;
        
        t2 = sqrt(tmp.^2 + deps);
        f = sum(fl((t2).^p)) * cvol;
        grad = D' * (tmp .* (t2.^(p-2)) * p);
        grad = reshape(grad', size(Knots)) * cvol;
end