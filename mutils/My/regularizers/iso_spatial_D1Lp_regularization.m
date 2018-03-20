function [f, grad] = iso_spatial_D1Lp_regularization(Knots, kspc, Nd, p, deps, edge_prior)
% function [f, grad] = iso_spatial_D1Lp_regularization(Knots, kspc, D, p, deps)

% Knots : sz1 - sz2 - sz3 - Nch - Nimgs
%         cvol = prod(pix_resolution .* grid_spacing);
%         D = generate_first_cyc_difference_matrix_for_image([size(Knots, 1), size(Knots, 2)], 1);

    if isempty(Nd)
        Nd = 2;
        if size(Knots, 3) > 1
            Nd = 3;
        end
    end
    gvol = prod(kspc);
    f = 0;
    grad = zeros(size(Knots), 'like', Knots);
    
    Nch = size(Knots, 4);
    ksz = size(Knots(:,:,:, 1));
    
%     Nch 
%     p
    
    for in = 1 : size(Knots, 5)
        tmp_reg = zeros(ksz);
        tmp_tg = cell(Nch, Nch);
        for i = 1 : Nch
            tmpt = Knots(:,:,:, i, in);
            Gt = cell(Nd, 1);
            if Nd == 3
                [Gt{1}, Gt{2}, Gt{3}] = my_gradient(tmpt, kspc);
            elseif Nd == 2
                [Gt{1}, Gt{2}] = my_gradient(tmpt, kspc(1:2));
            end
            for j = 1 : Nd
                loc_tmp = Gt{j};
                tmp_reg = tmp_reg + loc_tmp.^2;
                tmp_tg{i,j} = loc_tmp;
            end
        end
        if ~isempty(edge_prior)
            tmp_reg = sqrt(tmp_reg + deps + edge_prior);
        else
            tmp_reg = sqrt(tmp_reg + deps);
        end
        tmp_reg_2 = p * tmp_reg.^(p-2);
        for i = 1 : Nch
            if Nd == 3
                t1 = tmp_tg{i, 1} .* tmp_reg_2;
                t2 = tmp_tg{i, 2} .* tmp_reg_2;
                t3 = tmp_tg{i, 3} .* tmp_reg_2;
                tmp_gr = my_gradient(t1, kspc, 1)  + ...
                         my_gradient(t2, kspc, 2)  + ...
                         my_gradient(t3, kspc, 3);
                tmp_gr = reshape(tmp_gr, size(Knots(:,:,:, 1, in)));
                grad(:,:, :, i, in) = grad(:,:,:, i, in) + gvol * tmp_gr;
            elseif Nd == 2
                t1 = tmp_tg{i, 1} .* tmp_reg_2;
                t2 = tmp_tg{i, 2} .* tmp_reg_2;
                tmp_gr = my_gradient(t1, kspc(1:2), 1)  + ...
                         my_gradient(t2, kspc(1:2), 2);
                tmp_gr = reshape(tmp_gr, size(Knots(:,:,1)));
                grad(:,:, 1, i, in) = grad(:,:, 1, i, in) + gvol * tmp_gr;
            end
        end
        f = f + gvol * sum(tmp_reg(:).^p);
    end


%         D1 = D(1:end/2, :);
%         D2 = D(end/2+1:end, :);
%         D1x = D1 * fl(Knots(:,:, 1));
%         D2x = D2 * fl(Knots(:,:, 1));
%         
%         xlen2 = D1x.^2 + D2x.^2;
%         xlen = sqrt(xlen2 + deps);
%         f = sum(fl( xlen.^p ));
% %         tmp = p * xlen.^(p-1) ./ xlen;
%         tmp = p * xlen.^(p-2);
% %         tmp1 = p * xlen.^(p-1) .* (D1x) ./ xlen;
% %         tmp2 = p * xlen.^(p-1) .* (D2x) ./ xlen;
%         grad = D1' * (D1x.*tmp) + D2' * (D2x.*tmp);
% %         grad = D' * ((abs(tmp)+deps).^(p-1) .* sign(tmp)) * p;
%         grad = reshape(grad, size(Knots));
end