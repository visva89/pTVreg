function [Knots_n] = refine_cubic_grid_2d(Knots, old_spacing, old_vsz, new_spacing, new_vsz, varargin)
    %[Knots_n] = refine_linear_grid_3d(Knots, old_spacing, ds, volsz,
    %  {upsampling_type}
    Nd = size(Knots, 4);
    
    upsampling_type = 'sample_std';
    if nargin >= 6
        upsampling_type = varargin{1};
    end
    
    ksz_new = ceil(new_vsz(1:Nd) ./ new_spacing(1:Nd)) + 3;
    k = (old_vsz(1:Nd)) ./ (new_vsz(1:Nd));
    d = 2 * (1-k);
    interp_type = 1;

    tmp = cat(3, volresize_kd(squeeze(Knots(:,:,1)), k,d, interp_type), ...
                 volresize_kd(squeeze(Knots(:,:,2)), k,d, interp_type));
    if any(size(tmp) < [ksz_new,2])
        warning('Knots upsampling unexpected behavior');
        tmp2 = zeros([ksz_new, 2]);
        szs = min([size(tmp,1), size(tmp,2)], ksz_new);
        tmp2(1:szs(1), 1:szs(2),  :) = tmp(1:szs(1), 1:szs(2),  :);
        tmp = tmp2;
    end
    Kn = tmp(1:ksz_new(1), 1:ksz_new(2), :);
   
    Knots_n = Kn;
    if strcmp(upsampling_type, 'variation')
        Tmin = cubic_disp_2d(squeeze(Knots), old_vsz, old_spacing);
        Tmin_u = cat(3, imresize_my(Tmin(:,:, 1), new_vsz, 1), ...
                        imresize_my(Tmin(:,:, 2), new_vsz, 1));
        objf = @(x) align_knots(x, Tmin_u, new_vsz, [ksz_new, 2], new_spacing);
        uopt = []; uopt.method = 'cg'; 
        uopt.MaxIter = 10; 
        uopt.Corr = 15; 
        uopt.Display = 'off';
        uopt.DerivativeCheck = 'off';
        uopt.LS_type = 0; uopt.LS_init = 8;
        K2 = minFunc(objf, Kn(:), uopt);
        Knots_n = reshape(K2, [ksz_new, 2]);
    end
end


function [f, gr] = align_knots(K, T, szv, szk, grid_spacing)
    K = reshape(K, szk);
    Kx = cubic_disp_2d(K, szv, grid_spacing);
    df = Kx - T;
    f = sum(df(:).^2)/2;
    [gr1, gr2] = cubic_partial_conv_2d(df(:,:, 1), df(:,:, 2), size(K), grid_spacing);
    gr = [gr1(:); gr2(:)];
end
