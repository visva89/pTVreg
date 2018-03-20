% function [voldef, G] = cubic_disp_and_warp_and_grad_3d(Knots, vol, grid_spacing, pix_resolution, interp_type, out_val_type, out_val)
function [voldef, g1, g2, g3] = cubic_disp_and_warp_and_grad_3d(Knots, vol, grid_spacing, pix_resolution, interp_type, out_val_type, out_val)
    if ~strcmp(class(vol), class(Knots))
        error('im ~= T class');
    end
    
%     G = zeros([size(vol), 1, 3], 'like', vol);
    if isa(vol, 'double')
        T = cubic_disp_3d(Knots, size(vol), grid_spacing);
        voldef = imdeform3(vol, T, interp_type);
%         [G(:,:,:, 1, 1), G(:,:,:, 1, 2), G(:,:,:, 1, 3)] = ...
%                 my_gradient(voldef(:,:,:), pix_resolution, 0, 2);
        [g1, g2, g3] = ...
                my_gradient(voldef(:,:,:), pix_resolution, 0, 2);
    elseif isa(vol, 'single')
        error('Not implemented');
    elseif isa(vol, 'gpuArray')
        error('not implemented');
        if strcmp(classUnderlying(vol), 'single') 

        end
        if strcmp(classUnderlying(vol), 'double') 

        end
    end
end