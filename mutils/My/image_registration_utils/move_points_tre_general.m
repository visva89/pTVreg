function [pt_errs_phys, pts_moved_phys, TRE_phys, TREstd_phys] = move_points_tre_general(pts_mov_phys, ...
                        pts_fix_phys, Tr_phys, spc, lu_orig)
    if ~exist('lu_orig') || isempty(lu_orig)
        lu_orig = [0, 0, 0];
    end
    
    pts_moved_phys = 0 * pts_mov_phys;
    tsz = size(Tr_phys);
    tsz = tsz(1:3);
    for i = 1 : size(pts_mov_phys, 1)
        pos = round( (fl(pts_fix_phys(i, :))- lu_orig(:))./spc(:) );
        pos = min(pos, tsz(:));
        pos = max(pos, 1);
%                 pos
%         size(Tr_phys)
        pts_moved_phys(i, :) = (pts_fix_phys(i, :)' + fl(Tr_phys(pos(1), pos(2), pos(3), :)))';
    end
    
%     max(Tr_phys(:))
%     pts_moved_phys = bsxfun(@times, round(bsxfun(@rdivide, pts_moved_phys, spc)), spc);
%     pts_mov_phys = bsxfun(@times, round(bsxfun(@rdivide, pts_mov_phys, spc)), spc);
    
    pt_errs_phys = sqrt( sum((pts_moved_phys - pts_mov_phys).^2, 2) );
    
    
    
    TRE_phys = mean(pt_errs_phys);
    TREstd_phys = std(pt_errs_phys);
end