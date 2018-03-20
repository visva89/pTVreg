function [voldef, g1, g2] = linear_disp_and_warp_and_grad_2d(Knots, vol, grid_spacing, pix_resolution, interp_type, out_val_type, out_val)
    if ~strcmp(class(vol), class(Knots))
        error('im ~= T class');
    end
    
    G = zeros([size(vol), 1, 2], 'like', vol);
    if isa(vol, 'double')
        [voldef, g1, g2] = ...
                mex_2d_linear_disp_and_warp_and_grad_double(Knots, vol, ...
                    double(grid_spacing), double(pix_resolution), double(interp_type), double(out_val_type), double(out_val));
    elseif isa(vol, 'single')
        [voldef, g1, g2] = ...
                mex_2d_linear_disp_and_warp_and_grad_float(Knots, vol, ...
                    single(grid_spacing), single(pix_resolution), single(interp_type), single(out_val_type), single(out_val));
    elseif isa(vol, 'gpuArray')
        if strcmp(classUnderlying(vol), 'single') 
            error('not implemented');
        end
        if strcmp(classUnderlying(vol), 'double') 
            error('not implemented');
        end
    end
end