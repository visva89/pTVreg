% function [f, grad] = iso_spatial_D1Lp_regularization(Knots, kspc, Nd, p, deps)
function [f, grad] = iso_spatial_D2Lp_regularization(Knots, kspc, D1, D2, p, deps)

% Knots : sz1 - sz2 - sz3 - Nch - Nimgs
%         cvol = prod(pix_resolution .* grid_spacing);
%         D = generate_first_cyc_difference_matrix_for_image([size(Knots, 1), size(Knots, 2)], 1);
% 
%         D1 = D(1:end/2, :);
%         D2 = D(end/2+1:end, :);
%         D1 = D1 * D1;
%         D2 = D2 * D2;
        
        D1x = D1 * fl(Knots(:,:, 1));
        D2x = D2 * fl(Knots(:,:, 1));
        
        xlen2 = D1x.^2 + D2x.^2;
        xlen = sqrt(xlen2 + deps);
        f = sum(fl( xlen.^p ));
%         tmp = p * xlen.^(p-1) ./ xlen;
        tmp = p * xlen.^(p-2);
%         tmp1 = p * xlen.^(p-1) .* (D1x) ./ xlen;
%         tmp2 = p * xlen.^(p-1) .* (D2x) ./ xlen;
        grad = D1' * (D1x.*tmp) + D2' * (D2x.*tmp);
%         grad = D' * ((abs(tmp)+deps).^(p-1) .* sign(tmp)) * p;
        grad = reshape(grad, size(Knots));
end