function [f, grad] = isotropic_tv_regularization(Knots, kspc, ksz, AU, c)
        gvol = prod(kspc);

        nd = 2;
        if size(Knots, 3) > 1
            nd = 3;
        end
        Nch = size(Knots, 4);
        
        kspc = kspc(1:nd);
        
        k = 1;
        if isempty(ksz)
            ksz = size(Knots(:,:,:, 1));
        end
        grad = zeros(size(Knots), 'like', Knots);
        f = 0;
        
        for nn = 1 : size(Knots, 5)
            tmp_reg = zeros(ksz);
            tmp_tg = cell(Nch, nd);
            for i = 1 : Nch
                if nd == 3
                    t = Knots(:,:, :, i, nn);
                elseif nd == 2
                    t = Knots(:,:, 1, i, nn);
                end
                tmpt = AU*t(:);
                tmpt = reshape(tmpt, ksz);
                Gt = cell(nd,1);
                if nd == 3
                    [Gt{1}, Gt{2}, Gt{3}] = my_gradient(tmpt, kspc);
                elseif nd == 2
                    [Gt{1}, Gt{2}] = my_gradient(tmpt, kspc);
                end
                for j = 1 : nd
                    loc_tmp = Gt{j};
                    tmp_reg = tmp_reg + loc_tmp.^2;
                    tmp_tg{i,j} = loc_tmp;
                end
            end

            tmp_reg = sqrt(tmp_reg/k + c);
            for i = 1 : Nch
                if nd == 3
                    t1 = tmp_tg{i, 1} ./ tmp_reg;
                    t2 = tmp_tg{i, 2} ./ tmp_reg;
                    t3 = tmp_tg{i, 3} ./ tmp_reg;
                    tmp_gr = AU'* fl(my_gradient(t1, kspc, 1)  + ...
                        my_gradient(t2, kspc, 2) + ...
                        my_gradient(t3, kspc, 3));
                    tmp_gr = reshape(tmp_gr, size(Knots(:,:,:,1, nn)));
                    grad(:,:, :, i, nn) = grad(:,:,:, i, nn) + gvol * tmp_gr;
                elseif nd == 2
                    t1 = tmp_tg{i, 1} ./ tmp_reg;
                    t2 = tmp_tg{i, 2} ./ tmp_reg;
                    tmp_gr = AU'* fl(my_gradient(t1, kspc, 1)  + ...
                        my_gradient(t2, kspc, 2));
                    tmp_gr = reshape(tmp_gr, size(Knots(:,:,1)));
                    grad(:,:, 1, i, nn) = grad(:,:, 1, i, nn) + gvol * tmp_gr;
                end
            end
            f = f + gvol * sum(tmp_reg(:));
        end
end