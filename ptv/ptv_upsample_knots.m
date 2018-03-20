function Knots = ptv_upsample_knots(Knots_prev, imsz_prev, grid_spacing_prev, imsz_cur, grid_spacing_cur, k_down, method_type, K_ord, Nd)
% TODO 1: cache KT_temp? worth it??
% TODO 2: use lists
ksz_cur = ptv_get_grid_size(imsz_cur, grid_spacing_cur, K_ord);
ksz_prev = ptv_get_grid_size(imsz_prev, grid_spacing_prev, K_ord);

Knots = zeros([ksz_cur, size(Knots_prev, 4), size(Knots_prev, 5)], 'like', Knots_prev);

if K_ord == 1
    if Nd == 2
        for in = 1 : size(Knots_prev, 5)
            Knots(:,:,:,:, in) = refine_linear_grid_2d_v2(Knots_prev(:,:,1,:, in), grid_spacing_prev, imsz_prev, grid_spacing_cur, ...
                imsz_cur, 'variation');
        end
    elseif Nd == 3
        for in = 1 : size(Knots_prev, 5)
            Knots(:,:,:,:, in) = refine_linear_grid_3d_v2(Knots_prev(:,:,:,:, in), grid_spacing_prev, imsz_prev, grid_spacing_cur, ...
                imsz_cur, 'variation');
%             Knots(:,:,:,:, in) = refine_linear_grid_3d_v2(Knots_prev(:,:,:,:, in), grid_spacing_prev, imsz_prev, grid_spacing_cur, ...
%                 imsz_cur, []);
        end
    end
elseif K_ord == 3
    if Nd == 2
        for in = 1 : size(Knots_prev, 5)
            Knots(:,:,:,:, in) = refine_cubic_grid_2d(Knots_prev(:,:,1,:, in), grid_spacing_prev, imsz_prev, grid_spacing_cur, ...
                imsz_cur, 'variation');
        end
    elseif Nd == 3
        for in = 1 : size(Knots_prev, 5)
             Knots(:,:,:,:, in) = refine_cubic_grid_3d_v2(Knots_prev(:,:,:,:, in), grid_spacing_prev, imsz_prev, grid_spacing_cur, ...
                imsz_cur, 'variation');
%              Knots(:,:,:,:, in) = refine_cubic_grid_3d_v2(Knots_prev(:,:,:,:, in), grid_spacing_prev, imsz_prev, grid_spacing_cur, ...
%                 imsz_cur, '');
        end
    end
elseif K_ord == 3.5
    KT_temp = create_3d_image_upsample_matrix(ksz_prev, ksz_cur, 1);
    Knots_tmp = zeros([ksz_cur, size(Knots_prev, 4), 1]);
    for in = 1 : size(Knots_prev, 5)
        for ic = 1 : size(Knots_prev, 4)
            Knots_tmp(:,:,:, ic) = reshape(KT_temp * fl(Knots_prev(:,:,:, ic, in)), ksz_cur);
        end
        Knots(:,:,:,:, in) = Knots_tmp;
    end
elseif K_ord == -1 || K_ord == -2 || K_ord == -3 || K_ord == -4
    Knots = Knots_prev;
else
    error('Unknown K_ord');
end

% subplot(331);
% imagesc(Knots_prev(:,:, round(end/2), 1, 1)); colorbar;
% subplot(332);
% imagesc(Knots(:,:, round(end/2), 1, 1)); colorbar;
% 
% T_p = ptv_disp_from_knots(Knots_prev(:,:,:,:, 1), imsz_prev, grid_spacing_prev, K_ord, Nd, []);
% T_c = ptv_disp_from_knots(Knots(:,:,:,:, 1), imsz_cur, grid_spacing_cur, K_ord, Nd, []);
% subplot(333);
% imagesc(T_p(:,:, round(end/2), 1)); colorbar;
% subplot(334);
% imagesc(T_c(:,:, round(end/2), 1)); colorbar;
% subplot(335);
% if Nd == 3
%     T_pu = volresize(T_p(:,:,:, 1), imsz_cur, 0);
% elseif Nd == 2
%     T_pu = imresize_my(T_p(:,:, 1, 1), imsz_cur, 0);
% end
% imagesc(T_pu(:,:, round(end/2))); colorbar;
% subplot(336);
% imagesc(abs(T_c(:,:, round(end/2), 1) - T_pu(:,:, round(end/2)))); colorbar;
% norm(fl(T_c(:,:,:, 1) - T_pu(:,:,:))) / norm(fl(T_pu(:,:,:)))
% pause;

end
