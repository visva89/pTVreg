function [pt_errs_phys, pts_moved_pix, TRE_phys, TREstd_phys, pts_moved_r] = DIR_movepoints(pts_mov_pix, ...
                        pts_fix_pix, Tr_phys, spc, lu_orig)
    if ~exist('lu_orig') || isempty(lu_orig)
        lu_orig = [0, 0, 0];
    end
    
    pts_moved_pix = simple_move_points(pts_fix_pix, conv_3d_T_from_phys_to_pix(Tr_phys, spc), lu_orig);   
%     pts_moved_pix = simple_move_points_lerp(pts_fix_pix, conv_3d_T_from_phys_to_pix(Tr_phys, spc), lu_orig);
    pts_moved_r = pts_moved_pix;
    pts_moved_pix = round(pts_moved_pix);
    koef = repmat(spc, [size(pts_moved_pix, 1), 1]);
    pt_errs_phys = sqrt( sum((  (pts_moved_pix - pts_mov_pix).*koef  ).^2, 2) );
    TRE_phys = mean(pt_errs_phys);
    TREstd_phys = std(sqrt( sum((  (pts_moved_pix - pts_mov_pix).*koef  ).^2, 2) ));
end