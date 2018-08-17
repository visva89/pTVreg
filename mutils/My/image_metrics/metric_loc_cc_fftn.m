% function [err, g, perr] = metric_loc_cc_fftn(vol_fix, voldef, dvol, cache)
function varargout = metric_loc_cc_fftn(vol_fix, voldef, dvol, cache)
%       [err, g, perr]
    deps = cache.deps;
    sgm = cache.sigma;
    Nd = 3;
    if size(voldef, 3) == 1
        Nd = 2;
    end
    
    if strcmp(cache.metric_name, 'loc_cc_fftn_gpu')
        voldef = gpuArray((voldef));
    elseif strcmp(cache.metric_name, 'loc_cc_fftn_gpu_single')
        voldef = gpuArray(single(voldef));
    elseif strcmp(cache.metric_name, 'loc_cc_fftn_single')
        voldef = (single(voldef));
    end
    loc_cc_approximate = cache.loc_cc_approximate;
    
    pad_size = cache.pad_size;
    vol_fix_p = cache.vol_fix_p;
    fg = cache.fg;
    mean_fix = cache.mean_fix;
    sgm_fix = cache.sgm_fix;
    sgm_fix_inv = cache.sgm_fix_inv;
    
    start = cache.start;
    stop = cache.stop;
    voldef_p = padarray(voldef, pad_size, 'symmetric');
    
    if Nd == 2
        mycrop = @(x)x(start(1):stop(1), start(2):stop(2));
    elseif Nd == 3
        mycrop = @(x)x(start(1):stop(1), start(2):stop(2), start(3):stop(3));
    end
    
%     convop = @(fx) (ifftn(fftn(fx) .* fg, 'symmetric'));
    % which one is faster?
    convop = @(fx) real(ifftn(fftn(fx) .* fg));

%     tmp1 = ifftn(fftn(voldef_p) .* fg, 'symmetric');
%     tmp2 = real(ifftn(fftn(voldef_p) .* fg));
%     tmp1 = absifftn(fftn(voldef_p) .* fg);

    mean_def = convop(voldef_p);
    sgm_def = convop(voldef_p.^2) - mean_def.^2 + deps;
    sgm_def = sqrt(sgm_def);
    sprod = convop(vol_fix_p.*voldef_p) - mean_fix.*mean_def;
    
    sgm_d_f = sgm_def.*sgm_fix;
    
    sgm_d_f_inv = sgm_fix_inv ./ sgm_def;
    sgm_d3_f_inv = sgm_fix_inv./(sgm_def.^3);
    
    if true
        % masking is in sgm_fix
%         g = vol_fix_p .* convop(1./sgm_d_f) - ...
%             voldef_p  .* convop(sprod./sgm_d3_f) +...
%             convop(sprod .* mean_def./(sgm_d3_f) - mean_fix./sgm_d_f);
%         sprod_div_sgm_d3_f = sprod ./ sgm_d3_f;
%         g = vol_fix_p .* convop(1./sgm_d_f) - ...
%             voldef_p  .* convop(sprod_div_sgm_d3_f) +...
%             convop(sprod_div_sgm_d3_f .* mean_def - mean_fix./sgm_d_f);
        sprod_div_sgm_d3_f = sprod .* sgm_d3_f_inv;
        if loc_cc_approximate
     %         % approximation:
    %         g =  convop(vol_fix_p .*sgm_d_f_inv - ...
    %             voldef_p  .* sprod_div_sgm_d3_f +...
    %             sprod_div_sgm_d3_f .* mean_def - mean_fix.*sgm_d_f_inv);
    %         g =  convop((vol_fix_p - mean_fix) .*sgm_d_f_inv - ...
    %             (voldef_p - mean_def)  .* sprod_div_sgm_d3_f);
            g =  ((vol_fix_p - mean_fix) .*sgm_d_f_inv - ...
                (voldef_p - mean_def)  .* sprod_div_sgm_d3_f);
        else
            %%exact formula
            g = vol_fix_p .* convop(sgm_d_f_inv) - ...
                voldef_p  .* convop(sprod_div_sgm_d3_f) +...
                convop(sprod_div_sgm_d3_f .* mean_def - mean_fix.*sgm_d_f_inv);
        end
    else
        sgm_d3_f = sgm_fix.*sgm_def.^3;
        g = vol_fix_p .* convop(cache.maskfix_pad ./ sgm_d_f) - ...
            voldef_p  .* convop(cache.maskfix_pad .* sprod ./ sgm_d3_f) +...
            convop(cache.maskfix_pad .* (sprod .* mean_def ./ sgm_d3_f - mean_fix./sgm_d_f));
    end
    
    lcc = sprod ./ sgm_d_f;
    if ~isempty(cache.maskfix_pad)
        lcc = lcc .* cache.maskfix_pad;
    end
    
    lcc = mycrop(lcc);
    g = mycrop(g);
    
    loc_cc_abs = false;

    if isfield(cache, 'loc_cc_abs')
        loc_cc_abs = cache.loc_cc_abs;
    end
    if loc_cc_abs
%         tmp_sgn = sign(lcc);
        deps = 1e-2;
        tmp_sgn = lcc ./ sqrt(lcc.^2 + deps);
%         lcc = abs(lcc);
        lcc = sqrt(lcc.^2 + deps);
        g = g .* tmp_sgn;
    end
    
    lcc = (1-lcc) * dvol;
    g = -g * dvol;

    
    err = sum(sum(sum(lcc)));
    g = gather(g);
    
    if nargout >= 1
        err = convert_to_dtype(err, cache.internal_dtype);
        varargout{1} = err;
    end
    if nargout >= 2
        g = convert_to_dtype(g, cache.internal_dtype);
        varargout{2} = g;
    end
    if nargout >= 3
        perr = convert_to_dtype(lcc, cache.internal_dtype);
        varargout{3} = perr;
    end
    
%     subplot(141);
%     tmpss = reshape(mean_fix, size(voldef_p)); 
%     %imagesc([tmpss(:,:, round(end/2)), voldef_p(:,:, round(end/2)), vol_fix_p(:,:, round(end/2))]);
%     tmpss1 = reshape(mean_def, size(voldef_p)); 
%     tmpss2 = reshape(sgm_fix, size(voldef_p)); 
%     imagesc([tmpss1(:,:, round(end/2)), tmpss2(:,:, round(end/2))]);
%     subplot(142)
%     imagesc([tmpss2(:,:, round(end/2))]);
%     subplot(143);
%     tmpss = reshape(1-lcc/dvol, size(voldef)); 
%     imagesc([tmpss(:,:,round(end/2)) ]); caxis([0, 1]);
%     subplot(144);
%     imagesc([g(:,:,round(end/2)) ]); pause(0.01);
end

