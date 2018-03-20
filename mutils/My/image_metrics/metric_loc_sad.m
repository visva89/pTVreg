function [err, g, perr, cache] = metric_loc_sad(vol_fix, voldef, dvol, cache)
    de = 1e-7;
    sgm = 3;
%     sgm = 3 * 283/size(voldef,1);
%     sgm = max(sgm, 1);
%     sgm = 5;
    if false
        if isempty(cache) || ~isfield(cache, 'Mf')
            Mf = imgaussfilt3(vol_fix, sgm) + de;
            Nf = vol_fix ./ Mf;
            cache.Mf = Mf;
            cache.Nf = Nf;
            if strcmp(cache.metric, 'loc_sad_gpu')
                cache.Mf = gpuArray(Mf);
                cache.Nf = gpuArray(Nf);
            end
        else
            Mf = cache.Mf;
            Nf = cache.Nf;
        end
        if strcmp(cache.metric, 'loc_sad_gpu')
            voldef = gpuArray(voldef);
        end
        Md = imgaussfilt3(voldef, sgm) + de;
        Nd = voldef ./ Md;
        A = (Nd - Nf);
        sA = sign(A);
        perr = abs(A);
        err = sum(perr(:));
        tmp = voldef ./ (Md.^2) .* sA;
        g = sA ./ Md - imgaussfilt3(tmp, sgm);
        err = gather(err) * dvol;
        perr = gather(perr) * dvol;
        g = gather(g) * dvol;
    else
        op_G = @(x,y)real(ifftn(x .* y));
        metric_param = cache.metric_param;
        pix_resolution = cache.pix_resolution;
        d = 3;
        if isempty(cache) || ~isfield(cache, 'Mf')
            fww = min( min(round(size(voldef)/2)-0), max(metric_param)/2);
            G = get_gauss_kernel(fww, pix_resolution, ones(1, d));
            fw2 = floor(size(G)/2);

            s1 = next_good_factorization(size(voldef, 1) + 2*fw2(1), 8);
            s2 = next_good_factorization(size(voldef, 2) + 2*fw2(2), 8);
            s3 = next_good_factorization(size(voldef, 3) + 2*fw2(3), 8);
            fw = [s1, s2, s3] - size(voldef) - 2*fw2;

            Gi = zeros(size(voldef) + fw + 2 * fw2);
            Gi(1:size(G,1), 1:size(G,2), 1:size(G,3)) = G;
            shifts = floor(size(G)/2);
            Gi = circshift(circshift(circshift(Gi, -shifts(1), 1), -shifts(2), 2), -shifts(3), 3);
            fG = fftn(Gi);
%             imagesc(G(:,:,round(end/2))); pause;
            volfix_p = padarray(vol_fix, fw2, 'replicate');
            volfix_p = padarray(volfix_p, fw, 'replicate', 'post');

            f_fix = fftn(volfix_p);
            Mf = op_G(fG, f_fix) + de;
            Nf = volfix_p ./ Mf;
            
            cache.Mf = Mf;
            cache.Nf = Nf;
            cache.fG = fG;
            cache.fw = fw;
            cache.fw2 = fw2;
            if strcmp(cache.metric, 'loc_sad_gpu')
            	cache.Mf = gpuArray(Mf);
                cache.Nf = gpuArray(Nf);
                cache.fG = gpuArray(fG);
            end
            if strcmp(cache.internal_dtype, 'GPU_single')
                cache.Mf = convert_to_dtype(Mf, cache.internal_dtype);
                cache.Nf = convert_to_dtype(Nf, cache.internal_dtype);
                cache.fG = convert_to_dtype(fG, cache.internal_dtype);
            end
        else
            Mf = cache.Mf;
            Nf = cache.Nf;
            fG =cache.fG;
            fw = cache.fw;
            fw2 = cache.fw2;
        end
        if strcmp(cache.metric, 'loc_sad_gpu')
            voldef_p = gpuArray(voldef);
        else
            voldef_p = voldef;
        end
        voldef_p = padarray(voldef_p, fw2, 'replicate');
        voldef_p = padarray(voldef_p, fw, 'replicate', 'post');
        ffdef = fftn(voldef_p);
        Md = op_G(fG, ffdef)  + de;
        Nd = voldef_p ./ Md;
        A = (Nd - Nf);
        sA = sign(A);
        perr = abs(A);
        tmp = voldef_p ./ (Md.^2) .* sA;
        g = sA ./ Md - op_G(fG, fftn(tmp));
        
        perr = perr(1:end-fw(1), 1:end-fw(2), 1:end-fw(3));
        g = g(1:end-fw(1), 1:end-fw(2), 1:end-fw(3));
        perr = perr(1+fw2(1):end-fw2(1), 1+fw2(2):end-fw2(2), 1+fw2(3):end-fw2(3));
        g = g(1+fw2(1):end-fw2(1), 1+fw2(2):end-fw2(2), 1+fw2(3):end-fw2(3));
        
        err = sum(perr(:))* dvol;
        perr = perr * dvol;
        g = g * dvol;
        
%         err = gather(err);
%         perr = gather(perr);
%         g = gather(g);
        
    end
    
end