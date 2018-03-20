function [gr1, gr2, gr3] = cubic_partial_conv_3d(G1, G2, G3, ksz, spacing) %, interp_type, out_type, out_val)
% deform image
    if isa(G1, 'single')
        [gr1, gr2, gr3] = mex_3d_cubic_partial_conv_float(G1, G2, G3, single(ksz), single(spacing));
    elseif isa(G1, 'double')
        [gr1, gr2, gr3] = mex_3d_cubic_partial_conv_double(G1, G2, G3, double(ksz), double(spacing));
    elseif isa(G1, 'gpuArray') 
        error('Not implemented');
    else
        error('Variables class mismatch')
    end
end