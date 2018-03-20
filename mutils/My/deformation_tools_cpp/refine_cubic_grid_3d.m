function [Knots_n] = refine_cubic_grid_3d(Knots, spacing, old_spacing, ds, volsz, volsz_old)
%     Knots_sz = ceil(volsz ./ old_spacing) + 1;
%     volsz
%     old_spacing
%     ds
%     size(Knots)
%     Knots_sz
%     blyad = @(x) x(1:3);
%     blyad(size(Knots)) - ceil(Knots_sz./(ds+1)) + 3
%     Knots_n = cubic_disp_3d(Knots, Knots_sz, ds+1);
%     Knots_n = padarray(Knots_n, [1,1,1], 0);
    
    
    
    T = cubic_disp_3d(Knots, volsz_old, old_spacing);
    T2 = T(1:old_spacing(1)/2:end, 1:old_spacing(2)/2:end, 1:old_spacing(3)/2:end, :);
    Knots_n = padarray(T2, [1,1,1, 0], 'replicate');
    size(Knots_n)
    ceil(volsz ./ spacing) + 3
    
%     szdiff = ceil(volsz ./ spacing) + 3 - [size(Knots_n, 1), size(Knots_n, 2), size(Knots_n, 3)];
    szdiff = ceil((volsz-1) ./ spacing) + 3 - [size(Knots_n, 1), size(Knots_n, 2), size(Knots_n, 3)];
    Knots_n = padarray(Knots_n, szdiff, 'replicate', 'post');
    size(Knots_n)
    
    subplot(121);
    imagesc(Knots(:,:, round(end/2), 1)); colorbar;
    subplot(122);
    imagesc(Knots_n(:,:, round(end/2), 1)); colorbar;
    pause(1);
    fprintf('Refine %d %d\n', nnz(isnan(Knots)) + nnz(isinf(Knots)), nnz(isnan(Knots_n)) + nnz(isinf(Knots_n)));
end