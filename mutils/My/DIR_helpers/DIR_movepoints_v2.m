function [pt_errs_phys, pts_moved_pix, TRE_phys, TREstd_phys] = DIR_movepoints_v2(pts_mov_pix, ...
                        pts_fix_pix, spc_orig, spc_disp, D)
    pts_moved_pix = pts_fix_pix;
    D_pix = conv_3d_T_from_phys_to_pix(D, spc_disp);
    for i = 1 : size(pts_mov_pix, 1)
        x = fl( pts_fix_pix(i, :) - 1).*spc_orig(:)./spc_disp + 1;
        d1 = lerp_eval(x, D_pix(:,:,:,1));
        d2 = lerp_eval(x, D_pix(:,:,:,2));
        d3 = lerp_eval(x, D_pix(:,:,:,3));
        
        pts_moved_pix(i, :) =  pts_moved_pix(i,:) + [d1, d2, d3] .*spc_disp./spc_orig;
    end
    pts_moved_pix = round(pts_moved_pix);
    koef = repmat(spc_orig, [size(pts_moved_pix, 1), 1]);
    pt_errs_phys = sqrt( sum((  (pts_moved_pix - pts_mov_pix).*koef  ).^2, 2) );
    TRE_phys = mean(pt_errs_phys);
    TREstd_phys = std(sqrt( sum((  (pts_moved_pix - pts_mov_pix).*koef  ).^2, 2) ));
end