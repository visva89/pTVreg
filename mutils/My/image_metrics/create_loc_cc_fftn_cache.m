function cache = create_loc_cc_fftn_cache(metric, metric_param_pix, volmov, volfix, internal_dtype, maskfix, deps, loc_cc_approximate)
%     deps = 1e-5;
    Nd = 3;
    if size(volmov, 3) == 1
        Nd = 2;
    end
    szvolfix = [size(volfix, 1), size(volfix, 2), size(volfix, 3)];
    
    cache = [];
    if numel(metric_param_pix) == 1
        metric_param_pix = metric_param_pix * ones(1,Nd);
    end
    metric_param_pix = metric_param_pix(1:Nd);
    
    metr_threshold = 0.4;
    metr_threshold = 0.8;
    metric_param_pix(metric_param_pix < metr_threshold) = metr_threshold;
    sgm = metric_param_pix;
    hsz = max(2*ceil(2*sgm) + 1, 5);
    filterRadius = (hsz-1)/2;
    
    pad_size = ceil(filterRadius);
    start = pad_size+1;

    stop = start + size(volfix) - 1;
    vol_fix_p = padarray(volfix, pad_size, 'symmetric');
    
    if Nd == 2
        [n1, n2] = ndgrid(1:size(vol_fix_p,1), 1:size(vol_fix_p,2));
    elseif Nd == 3
        [n1, n2, n3] = ndgrid(1:size(vol_fix_p,1), 1:size(vol_fix_p,2), 1:size(vol_fix_p,3));
    end
    c = ceil(size(n1)/2)+1;
    if Nd == 2
        g = exp(- (n1-c(1)).^2/(2*sgm(1)^2) - (n2-c(2)).^2/(2*sgm(2)^2));
    elseif Nd == 3
        g = exp(- (n1-c(1)).^2/(2*sgm(1)^2) - (n2-c(2)).^2/(2*sgm(2)^2) - (n3-c(3)).^2/(2*sgm(3)^2));
    end
    
    g = g/sum(g(:));
    g = fftshift(g);
    fg = fftn(g, size(vol_fix_p));
    convop = @(fx) (ifftn(fftn(fx) .* fg, 'symmetric'));

    mean_fix = convop(vol_fix_p);
    sgm_fix = convop(vol_fix_p.^2) - mean_fix.^2 + deps;
    sgm_fix = sqrt(sgm_fix);
    
%     maskfix_pad = [];
    if ~isempty(maskfix)
        maskfix_pad = padarray(maskfix, pad_size, 'symmetric');
        sgm_fix = sgm_fix ./ maskfix_pad;
        sgm_fix_inv = maskfix_pad ./ sgm_fix;
    else
        sgm_fix_inv = 1 ./ sgm_fix;
    end
    
    cache.fg = fg;
    cache.vol_fix_p = vol_fix_p;
    cache.mean_fix = mean_fix;
    cache.sgm_fix = sgm_fix;
    cache.sgm_fix_inv = sgm_fix_inv;
    cache.start = start;
    cache.stop = stop;
    
    cache.pad_size = pad_size;
    cache.metric_name = metric;
    cache.sigma = metric_param_pix;
    cache.internal_dtype = internal_dtype;
    cache.deps = deps;
%     cache.maskfix = maskfix;
%     cache.maskfix_pad = maskfix_pad;
    cache.maskfix_pad = [];
    cache.loc_cc_approximate = loc_cc_approximate;
    
    if strcmp(metric, 'loc_cc_fftn_gpu')
        cache.fg = gpuArray((cache.fg));
        cache.vol_fix_p = gpuArray((cache.vol_fix_p));
        cache.mean_fix = gpuArray((cache.mean_fix));
        cache.sgm_fix = gpuArray((cache.sgm_fix));
        cache.deps = gpuArray(cache.deps);
        cache.sgm_fix_inv = gpuArray(sgm_fix_inv);
%         cache.maskfix = gpuArray(cache.maskfix);
%         cache.maskfix_pad = gpuArray(cache.maskfix_pad);
    elseif strcmp(metric, 'loc_cc_fftn_gpu_single')
        cache.fg = gpuArray(single(cache.fg));
        cache.vol_fix_p = gpuArray(single(cache.vol_fix_p));
        cache.mean_fix = gpuArray(single(cache.mean_fix));
        cache.sgm_fix = gpuArray(single(cache.sgm_fix));
        cache.deps = gpuArray(single(cache.deps));
        cache.sgm_fix_inv = gpuArray(single(sgm_fix_inv));
%         cache.maskfix = gpuArray(single(cache.maskfix));
%         cache.maskfix_pad = gpuArray(single(cache.maskfix_pad));
    elseif strcmp(metric, 'loc_cc_fftn_single')
        cache.fg = (single(cache.fg));
        cache.vol_fix_p = (single(cache.vol_fix_p));
        cache.mean_fix = (single(cache.mean_fix));
        cache.sgm_fix = (single(cache.sgm_fix));
        cache.deps = (single(cache.deps));
        cache.sgm_fix_inv = (single(sgm_fix_inv));
    end
end