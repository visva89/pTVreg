function D = linear_disp_3d(Knots, volsz, spacing) %, interp_type, out_type, out_val)
% deform image
    if isa(Knots, 'single')
        D = mex_3d_linear_disp_float(Knots, single(volsz), single(spacing));
    elseif isa(Knots, 'double')
        D = mex_3d_linear_disp_double(Knots, volsz, spacing);
    elseif isa(Knots, 'gpuArray') 
        if strcmp(classUnderlying(Knots), 'single') 
            D = mex_3d_linear_disp_GPU_float(Knots, single(volsz), single(spacing));
        end
    else
        error('Variables class mismatch')
    end
end