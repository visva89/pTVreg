function [gr1, gr2] = linear_partial_conv_2d(G1, G2, ksz, spacing) %, interp_type, out_type, out_val)
% deform image
    if all(spacing(:) == [1;1])
        gr1 = zeros(ksz(1:2));
        gr2 = zeros(ksz(1:2));
        gr1(1:size(G1,1), 1:size(G1,2)) = G1;
        gr2(1:size(G1,1), 1:size(G1,2)) = G2;
        return;
    end
    
    if isa(G1, 'single')
        [gr1, gr2] = mex_2d_linear_partial_conv_float(G1, G2, single(ksz), single(spacing));
    elseif isa(G1, 'double')
        [gr1, gr2] = mex_2d_linear_partial_conv_double(G1, G2, double(ksz), double(spacing));
    elseif isa(G1, 'gpuArray') 
        if strcmp(classUnderlying(G1), 'single') 
            error('Not implemented');
            [gr1, gr2] = mex_3d_linear_partial_conv_GPU_float(G1, G2, single(ksz), single(spacing));
        end
    else
        error('Variables class mismatch')
    end
end