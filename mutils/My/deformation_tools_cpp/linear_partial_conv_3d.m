function [gr1, gr2, gr3] = linear_partial_conv_3d(G1, G2, G3, ksz, spacing) %, interp_type, out_type, out_val)
% deform image
    if isa(G1, 'single')
        [gr1, gr2, gr3] = mex_3d_linear_partial_conv_float(G1, G2, G3, single(ksz), single(spacing));
%         [gr1d, gr2d, gr3d] = mex_3d_linear_partial_conv_double(double(G1), double(G2), double(G3), double(ksz), double(spacing));
%         max(fl(abs([gr1(:);gr2(:);gr3(:)] - [gr1d(:);gr2d(:);gr3d(:)])))
    elseif isa(G1, 'double')
        [gr1, gr2, gr3] = mex_3d_linear_partial_conv_double(G1, G2, G3, double(ksz), double(spacing));
    elseif isa(G1, 'gpuArray') 
        if strcmp(classUnderlying(G1), 'single') 
            [gr1, gr2, gr3] = mex_3d_linear_partial_conv_GPU_float(G1, G2, G3, single(ksz), single(spacing));
        end
        if strcmp(classUnderlying(G1), 'double') 
            [gr1, gr2, gr3] = mex_3d_linear_partial_conv_GPU_double(G1, G2, G3, double(ksz), double(spacing));
        end
    else
        error('Variables class mismatch')
    end
end