function [gr1, gr2] = cubic_partial_conv_2d(G1, G2, ksz, spacing) %, interp_type, out_type, out_val)
% deform image
    if isa(G1, 'single')
        [gr1, gr2] = mex_2d_cubic_partial_conv_float(G1, G2, single(ksz), single(spacing));
    elseif isa(G1, 'double')
        [gr1, gr2] = mex_2d_cubic_partial_conv_double(G1, G2, double(ksz), double(spacing));
    elseif isa(G1, 'gpuArray') 
        error('Not implemented');
    else
        error('Variables class mismatch')
    end
end