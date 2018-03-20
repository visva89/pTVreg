function voldef = linear_disp_and_warp_3d(Knots, vol, grid_spacing, interp_type, out_val_type, out_val)
    if ~strcmp(class(vol), class(Knots))
        error('im ~= T class');
    end
    
    if isa(vol, 'double')
        voldef = mex_3d_linear_disp_and_warp_double(Knots, vol, grid_spacing, interp_type, out_val_type, out_val);
    elseif isa(vol, 'single')
        voldef = mex_3d_linear_disp_and_warp_float(single(Knots), single(vol), ...
            single(grid_spacing), single(interp_type), single(out_val_type), single(out_val));
%         voldefd = mex_3d_linear_disp_and_warp_double(double(Knots), double(vol), double(grid_spacing), ...
%             double(interp_type), double(out_val_type), double(out_val));
% %         voldef(isnan(voldef)) = 0;
%         if max(fl(abs(voldef-voldefd))) > 0.001
%             fprintf('maxd=%.3f\n', max(fl(abs(voldef-voldefd))));
%         end
%         voldef = single(voldefd);
    elseif isa(vol, 'gpuArray')
        if strcmp(classUnderlying(vol), 'single') 
%             D = mex_3d_linear_disp_GPU_float(Knots, single(size(vol)), single(grid_spacing));
%             voldef = mex_3d_volume_warp_GPU_float(vol, D, single(0));
            voldef = mex_3d_linear_disp_and_warp_notex_GPU_float(Knots, vol, single(grid_spacing), interp_type);
        end
        if strcmp(classUnderlying(vol), 'double') 
            voldef = mex_3d_linear_disp_and_warp_notex_GPU_double(Knots, vol, double(grid_spacing), interp_type);
        end
    end
end