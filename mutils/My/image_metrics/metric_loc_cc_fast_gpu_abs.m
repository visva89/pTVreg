function [err, g, perr] = metric_loc_cc_fast_gpu_abs(vol_fix, voldef, dvol, cache)
    op_G = @(x,y)real(ifft(x .* y));
    myeps = 1e-8;
    type = 'approximate';
%     type = 'exact';
    use_single = false;
    if use_single 
        vol_fix = single(vol_fix);
        voldef = single(voldef);
    end
    
    if isempty(cache)
         metric_param = 15;
        pix_resolution = [1,1,1];
        cache = create_lncc_cache('loc_cc_fast_gpu', metric_param, voldef, vol_fix, pix_resolution);
        cache.fixed_mask = [];
        warning('Something wrong');
    end
    
    if ~isempty(cache)
        fG = cache.cu_fG;
%         f_fix = cache.cu_f_fix;
        mean_fix = cache.cu_mean_fix;
%         fft_vol_fix_2 = cache.cu_fft_vol_fix_2;
        sgm_fix = cache.cu_sgm_fix;
        volfix_p = cache.cu_volfix_p;
        fw = cache.fw;
    else
       
    end
%     voldef_p = padarray(voldef, [1,1,1]*fw);
%     voldef_p = gpuArray(voldef_p);
    
    voldef_p = gpuArray(voldef);
    voldef_p = padarray(voldef_p, [1,1,1]*fw);
    
    f_def = fft(voldef_p(:));
    
    mean_def = op_G(fG, f_def);
    sprod = op_G(fG, fft(volfix_p(:).*voldef_p(:))) - mean_fix.*mean_def;
%     sgm_def = abs(real(sqrt(abs(op_G(fG, fft(voldef_p(:).^2)) - mean_def.^2)))); %+0*myeps;
%     sgm_def = sqrt(abs(op_G(fG, fft(voldef_p(:).^2)) - mean_def.^2));
    
    sgm_def = op_G(fG, fft(voldef_p(:).^2)) - mean_def.^2;
    sgm_def(sgm_def < eps) = eps;
    sgm_def = sqrt(sgm_def);
    
    sgm_d_f = sgm_def.*sgm_fix;
%     sgm_d_f(abs(sgm_d_f) < myeps) = myeps * sign(sgm_d_f(abs(sgm_d_f)<myeps));
    sgm_d_f(sgm_d_f==0) = myeps;
    if strcmp(type, 'exact')
        sgm_d3_f = sgm_fix.*sgm_def.^3;
        sgm_d3_f(abs(sgm_d3_f) < myeps) = myeps * sign(sgm_d3_f(abs(sgm_d3_f)<myeps));
        sgm_d3_f(sgm_d3_f == 0) = myeps;
        g = vol_fix(:) .* op_G(fG, fft(1./sgm_d_f)) - voldef(:) .* op_G(fG, fft(sprod./(sgm_d3_f))) +...
            op_G(fG, fft(sprod .* mean_def./(sgm_d3_f) - mean_fix./sgm_d_f));
    elseif strcmp(type, 'approximate')
        sgm_d2 = sgm_def.^2;
%         sgm_d2(abs(sgm_d2) < myeps) = myeps * sign(sgm_d2(abs(sgm_d2)<myeps));
%         sgm_d2(sgm_d2 == 0) = myeps;
        g = (volfix_p(:) - mean_fix(:) - (voldef_p(:) - mean_def(:)) .* ...
            sprod ./ (sgm_d2)) ./ (sgm_d_f);
    end
    lcc = sprod ./ sgm_d_f;
    
    lcc = reshape(lcc, size(voldef_p));
    g = reshape(g, size(voldef_p));
    lcc = lcc(fw+1:end-fw, fw+1:end-fw, fw+1:end-fw);
    g = g(fw+1:end-fw, fw+1:end-fw, fw+1:end-fw);

    lcc = (1 - abs(lcc)) * dvol;
    g = (1 - sign(lcc).*g) * dvol;
    if ~isempty(cache.fixed_mask)
        lcc = gather(lcc);
        g = gather(g);
        lcc = lcc .* cache.fixed_mask;
        g = g .* cache.fixed_mask;
    end
    
    err = sum(sum(sum(lcc)));
    g = gather(g);
    
    err = double(gather(err));
    perr = double(gather(lcc));
    g = double(reshape(g, size(voldef)));
end