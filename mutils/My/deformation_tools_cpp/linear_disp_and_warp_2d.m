function imgdef = linear_disp_and_warp_2d(Knots, img, grid_spacing, interp_type, out_val_type, out_val)
    if isa(img, 'double')
        imgdef = mex_2d_linear_disp_and_warp_double(Knots, img, grid_spacing, interp_type, out_val_type, out_val);
    elseif isa(img, 'single')
        imgdef = mex_2d_linear_disp_and_warp_float(Knots, img, single(grid_spacing), single(interp_type), single(out_val_type), single(out_val));
    else isa(img, 'gpuArray')
        error('Not implemented');
    end
end