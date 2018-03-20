function [Knots_n] = refine_linear_grid_2d(Knots, old_spacing, ds, imgsz, varargin)
    k_down = 0.5;
    if nargin >= 5
        k_down = varargin{1};
    end
    if k_down == 0.5
        Knots_sz = ceil(imgsz ./ old_spacing) + 1;
        Knots_n = linear_disp_2d(Knots, Knots_sz, ds+1);
    else
        interp_type = 0;
        ksz2 = ceil(imgsz ./ old_spacing) + 1;
        tmp = cat(3, imresize_my(Knots(:,:,1), ksz2, interp_type, 'for_upsampling_2'), ...
                     imresize_my(Knots(:,:,2), ksz2, interp_type, 'for_upsampling_2'));
        Knots_n = tmp;
    end
    
%     if all( fl(Knots_n(:,end, 1)) == 0)
%         Knots_n(:,end,1) = Knots_n(:,end-1,1);
%     end
%     if all( fl(Knots_n(:,end, 2)) == 0)
%         Knots_n(:,end,2) = Knots_n(:,end-1,2);
%     end
%     if all( fl(Knots_n(end, :, 1)) == 0)
%         Knots_n(end, :, 1) = Knots_n(end-1, :, 1);
%     end
%     if all( fl(Knots_n(end, :, 2)) == 0)
%         Knots_n(end, :, 2) = Knots_n(end-1, :, 2);
%     end
%     size(Knots)
%     Knots_sz
%     ds+1
    
    
%     K1 = imresize(Knots(:,:,1), Knots_sz, 'cubic');
%     K2 = imresize(Knots(:,:,2), Knots_sz, 'cubic');
%     Knots_n = cat(3, K1, K2);
    
%     figure; imagesc(Knots(:,:,1)); colorbar;
%     figure; imagesc(Knots_n(:,:,1)); colorbar;
%     pause;
    
%     T = mex_2d_linear_disp_double(Knots, imgsz, old_spacing);
%     ksz = ceil(imgsz ./ new_spacing) + 1;
%     Knots_n =...
%         T([1, round(1:new_spacing(1):imgsz(1))], ...
%           [1, round(1:new_spacing(2):imgsz(2))], ...
%           :);
    
end