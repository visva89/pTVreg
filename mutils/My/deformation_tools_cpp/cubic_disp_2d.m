function D = cubic_disp_2d(Knots, volsz, spacing) 
% deform image
    if isa(Knots, 'single')
        D = mex_2d_cubic_disp_float(Knots, single(volsz), single(spacing));
    elseif isa(Knots, 'double')
        D = mex_2d_cubic_disp_double(Knots, volsz, spacing);
    elseif isa(Knots, 'gpuArray') 
        error('Not implemented')
    else
        error('Variables class mismatch')
    end
end