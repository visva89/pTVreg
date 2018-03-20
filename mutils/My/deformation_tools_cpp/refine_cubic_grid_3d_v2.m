function [Knots_n] = refine_cubic_grid_3d_v2(Knots, old_spacing, old_vsz, new_spacing, new_vsz, varargin)
    %[Knots_n] = refine_linear_grid_3d(Knots, old_spacing, ds, volsz,
    %  {upsampling_type}
    Nd = size(Knots, 4);
    
    upsampling_type = 'sample_std';
    if nargin >= 6
        upsampling_type = varargin{1};
    end
    
    if false
        ksz_new = ceil(new_vsz ./ new_spacing) + 3;
        Kn = zeros([ksz_new, 3]);
        interp_type = 1;
        tmp = cat(4, volresize(Knots(:,:,:,1), ksz_new, interp_type), ...
                     volresize(Knots(:,:,:,2), ksz_new, interp_type), ...
                     volresize(Knots(:,:,:,3), ksz_new, interp_type));
        Kn = tmp;
    elseif false
        new_vsz ./ old_vsz
%         ksz_new = round(fl( (new_vsz-1) ./ (old_vsz-1)) .* fl([size(Knots, 1), size(Knots, 2), size(Knots, 3)]))';
        ksz_new = round(fl( (new_vsz) ./ (old_vsz)) .* fl([size(Knots, 1), size(Knots, 2), size(Knots, 3)] - 2))';
        interp_type = 1;
        tmp = cat(4, volresize(Knots(2:end,2:end,2:end,1), ksz_new, interp_type), ...
                     volresize(Knots(2:end,2:end,2:end,2), ksz_new, interp_type), ...
                     volresize(Knots(2:end,2:end,2:end,3), ksz_new, interp_type));
        ksz_true = ceil(new_vsz ./ new_spacing) + 3;
        
        size(tmp)
%         Kn = tmp(1:ksz_true(1), 1:ksz_true(2), 1:ksz_true(3), :);
        Kn = zeros([ksz_true, 3]);
        Kn(2:size(tmp, 1)+1, 2:size(tmp, 2)+1, 2:size(tmp, 3)+1, :) = tmp(1:min(size(tmp,1), size(Kn,1)-1), 1:min(size(tmp,2), size(Kn,2)-1), 1:min(size(tmp,3), size(Kn,3)-1), :);
        size(Kn)
        ksz_true
        ksz_new = ksz_true;
   elseif true
        ksz_old = [size(Knots, 1), size(Knots, 2), size(Knots, 3)];
        ksz_new = ceil(new_vsz ./ new_spacing) + 3;
%         k = (ksz_old - 3) ./ (ksz_new - 3);
        k = (old_vsz) ./ (new_vsz);
        d = 2 * (1-k);
        interp_type = 1;
        tmp = cat(4, volresize_kd(Knots(:,:,:,1), k,d, interp_type), ...
                     volresize_kd(Knots(:,:,:,2), k,d, interp_type), ...
                     volresize_kd(Knots(:,:,:,3), k,d, interp_type));
        if any(size(tmp) < [ksz_new,3])
            warning('Knots upsampling unexpected behavior');
            tmp2 = zeros([ksz_new, 3]);
            szs = min([size(tmp,1), size(tmp,2), size(tmp,3)], ksz_new);
            tmp2(1:szs(1), 1:szs(2), 1:szs(3), :) = tmp(1:szs(1), 1:szs(2), 1:szs(3), :);
            tmp = tmp2;
        end
        Kn = tmp(1:ksz_new(1), 1:ksz_new(2), 1:ksz_new(3), :);
   elseif false
        Tmin = cubic_disp_3d(Knots, old_vsz, old_spacing);
        Tmin_u = cat(4, volresize(Tmin(:,:,:, 1), new_vsz, 1), ...
                        volresize(Tmin(:,:,:, 2), new_vsz, 1), ...
                        volresize(Tmin(:,:,:, 3), new_vsz, 1));
        tmp = Tmin_u(1:new_spacing(1):end, 1:new_spacing(2):end, 1:new_spacing(3):end, :);
        ksz_true = ceil(new_vsz ./ new_spacing) + 3;
        ksz_true
        size(tmp)
        size(Tmin_u)
        Kn = zeros([ksz_true, 3]);
        Kn(1:size(tmp, 1), 1:size(tmp, 2), 1:size(tmp, 3), :) = tmp;
        ksz_new = ksz_true;
    end
    
    Knots_n = Kn;
    if strcmp(upsampling_type, 'variation')
        Tmin = cubic_disp_3d(Knots, old_vsz, old_spacing);
        Tmin_u = cat(4, volresize(Tmin(:,:,:, 1), new_vsz, 1), ...
                        volresize(Tmin(:,:,:, 2), new_vsz, 1), ...
                        volresize(Tmin(:,:,:, 3), new_vsz, 1));
        objf = @(x) align_knots(x, Tmin_u, new_vsz, [ksz_new, 3], new_spacing);
        uopt = []; uopt.method = 'cg'; 
        uopt.MaxIter = 10; 
        uopt.Corr = 15; 
        uopt.Display = 'off';
        uopt.DerivativeCheck = 'off';
        uopt.LS_type = 0; uopt.LS_init = 8;
        K2 = minFunc(objf, Kn(:), uopt);
        Knots_n = reshape(K2, [ksz_new, 3]);
    end
end


function [f, gr] = align_knots(K, T, szv, szk, grid_spacing)
    K = reshape(K, szk);
    Kx = cubic_disp_3d(K, szv, grid_spacing);
    df = Kx - T;
    f = sum(df(:).^2)/2;
    [gr1, gr2, gr3] = cubic_partial_conv_3d(df(:,:,:, 1), df(:,:,:, 2), df(:,:,:, 3), size(K), grid_spacing);
    gr = [gr1(:); gr2(:); gr3(:)];
end
