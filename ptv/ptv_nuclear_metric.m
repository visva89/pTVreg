function [err_N, sG] = ptv_nuclear_metric(volfix, voldef, pix_resolution, mask, singular_coefs, norm_type)
    volsz = [size(voldef, 1), size(voldef, 2), size(voldef, 3)]; 
    npix = prod(volsz);
    Nimgs = size(voldef, 5);
    
%     nuc_G = zeros(size(voldef), 'like', voldef);
    err_N = 0;
    
%     imagesc([voldef(:,:, round(end/2), 1, 1), volfix(:,:, round(end/2), 1, 1)]); pause(0.02);
%     imagesc([ mean(voldef(:,:, round(end/2), 1, :), 5)]); pause(0.02);
    
    if isempty(singular_coefs)
        singular_coefs = fl(sqrt(1:Nimgs));
        singular_coefs(1) = 0;
    end
    
    if isempty(volfix)
        X = reshape(voldef, [npix, Nimgs]);
    else
        X = reshape(cat(5, volfix, voldef), [npix, Nimgs+1]);
        if numel(singular_coefs > 1)
%             singular_coefs = [0, 1, singular_coefs(2:end)];
%             singular_coefs = [fl(singular_coefs(1:end)); singular_coefs(end)];
%             singular_coefs = fl(sqrt(1:(Nimgs+1)));
%             singular_coefs
        end
    end
    if ~isempty(mask)
        mask = logical(mask > 0.5);
        X = X(mask, :);
    end
    singular_coefs = singular_coefs(1 : min(numel(singular_coefs), size(X, 1)));
    [sU, sS, sV] = svdecon(X);
%     sS
    diagS = diag(sS);
    if false
        sGt = sU * ( (diag(singular_coefs)) * sV');
        err_N = sum(diagS(:) .* singular_coefs(:));
    else
        eps = 1e-4;
%         eps=0.1;
        G_sS = diagS ./ sqrt(diagS.^2 + eps);
        sGt = sU * ( (diag(singular_coefs(:) .* G_sS(:))) * sV');
        err_N = sum( sqrt(diagS.^2 + eps) .* singular_coefs(:));
    end
    
%     if true
%         sk1 = sqrt(1 : size(singular_coefs, 1));
%         sk2 = sk1;
%         sk2(1) = 0;
%         
%         sk3 = ones(size(singular_coefs, 1), 1);
%         sk4 = sk3;
%         sk4(1) = 0;
%         
%         size(sk1)
%         subplot(221);
%         itmp = reshape(sU * (diag(sk1) * sV'), [volsz, Nimgs]);
%         imagesc(itmp(:,:, 70)); colorbar;
%         
%         subplot(222);
%         itmp = reshape(sU * (diag(sk2) * sV'), [volsz, Nimgs]);
%         imagesc(itmp(:,:, 70)); colorbar;
%         
%         subplot(223);
%         itmp = reshape(sU * (diag(sk3) * sV'), [volsz, Nimgs]);
%         imagesc(itmp(:,:, 70)); colorbar;
%         
%         subplot(224);
%         itmp = reshape(sU * (diag(sk4) * sV'), [volsz, Nimgs]);
%         imagesc(itmp(:,:, 70)); colorbar;
%         
%         pause(0.05);
%         pause();
%     end
    
    if isempty(volfix)
        if ~isempty(mask)
            sG = zeros([npix, Nimgs], 'like', voldef);
            sG(mask, :) = reshape(sGt, [nnz(mask), Nimgs]);
            sG = reshape(sG, [volsz, Nimgs]);
        else
            sG = reshape(sGt, [volsz, Nimgs]);
        end
    else
        if ~isempty(mask)
            sG = zeros([npix, Nimgs+1], 'like', voldef);
            sG(mask, :) = reshape(sGt, [nnz(mask), Nimgs+1]);
            sG = reshape(sG, [volsz, Nimgs+1]);
        else
            sG = reshape(sGt, [volsz, Nimgs+1]);
        end
        sG = sG(:,:,:, 2:end);
    end
    

end