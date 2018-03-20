function [err, g, perr] = eval_metric(metric, imfix, imdef, pix_resolution, opts, mask)
    perr = 0;
    if strcmp(metric, 'ssd')
        [err, g, perr] = metric_ssd(imfix, imdef, prod(pix_resolution), mask);
    elseif strcmp(metric, 'sad')  
        [err, g, perr] = metric_sad(imfix, imdef, prod(pix_resolution), mask);
    elseif strcmp(metric, 'ngf')
        perr = 0;
        [err, g, ~] = metric_ngf(imfix, imdef, pix_resolution, []);
    elseif strcmp(metric, 'loc_cc_fftn') || strcmp(metric, 'loc_cc_fftn_single') || strcmp(metric, 'loc_cc_fftn_gpu') || strcmp(metric, 'loc_cc_fftn_gpu_single')
        perr = 0;
        [err, g] = metric_loc_cc_fftn(imfix, imdef, prod(pix_resolution), opts.cache);
    elseif strcmp(metric, 'logssd')
        [err, g] = metric_logssd(imfix, imdef, prod(pix_resolution));
    elseif strcmp(metric, 'loc_sad')||strcmp(metric, 'loc_sad_gpu')
        opts.cache.metric = metric;
        [err, g, perr] = metric_loc_sad(imfix, imdef, prod(pix_resolution), opts.cache);
    elseif strcmp(metric, 'LCC_imgf') 
        cache = [];
        if ~isempty(opts) && isfield(opts, 'cache')
            cache = opts.cache;
        end
        [err, g, perr] = metric_loc_cc_imgf(imfix, imdef, prod(pix_resolution), cache);
    elseif strcmp(metric, 'LCC_imgf_gpu')
        cache = [];
        if ~isempty(opts) && isfield(opts, 'cache')
            cache = opts.cache;
        end
        gimfix = cache.imfix_gpu;
        gimdef = gpuArray(imdef);
        [err, g, perr] = metric_loc_cc_imgf(gimfix, gimdef, prod(pix_resolution), cache);
%     elseif strcmp(metric, 'loc_cc_fast')
%         cache = [];
%         if ~isempty(opts) && isfield(opts, 'cache')
%             cache = opts.cache;
%         end
%         [err, g, perr] = metric_loc_cc_fast(imfix, imdef, prod(pix_resolution), cache);
    elseif strcmp(metric, 'loc_cc_fast_gpu') || strcmp(metric, 'loc_cc_fast')
        cache = [];
        if ~isempty(opts) && isfield(opts, 'cache')
            cache = opts.cache;
        end
        cache.fixed_mask = mask;
%        try
            [err, g, perr] = metric_loc_cc_fast_gpu(imfix, imdef, prod(pix_resolution), cache);
%         catch ME
%             fprintf('Cuda ERROR\n');
% %             warning(getReport(ME));
%            [err, g] = metric_loc_cc_fast(imfix, imdef, prod(pix_resolution), cache);
%         end
    elseif strcmp(metric, 'loc_cc_fast_gpu_fftn') || strcmp(metric, 'loc_cc_fast_fftn')
        cache = [];
        if ~isempty(opts) && isfield(opts, 'cache')
            cache = opts.cache;
        end
        [err, g, perr] = metric_loc_cc_fast_gpu_fftn(imfix, imdef, prod(pix_resolution), cache);
    elseif strcmp(metric, 'loc_cc_fast_gpu_abs')
        cache = [];
        if ~isempty(opts) && isfield(opts, 'cache')
            cache = opts.cache;
        end
        [err, g, perr] = metric_loc_cc_fast_gpu_abs(imfix, imdef, prod(pix_resolution), cache);
    elseif strcmp(metric, 'loc_cc_fast_iir')
        cache = [];
        if ~isempty(opts) && isfield(opts, 'cache')
            cache = opts.cache;
        end
        [err, g, perr] = metric_loc_cc_fast_iir(imfix, imdef, prod(pix_resolution), cache);
    elseif strcmp(metric, 'loc_cc_fast_iir_abs')
        cache = [];
        if ~isempty(opts) && isfield(opts, 'cache')
            cache = opts.cache;
        end
        [err, g, perr] = metric_loc_cc_fast_iir_abs(imfix, imdef, prod(pix_resolution), cache);
    elseif strcmp(metric, 'ngf')
        tau = 0.005;
        [err, g] = NGF3_mex(imdef, imfix, tau);
    end
end