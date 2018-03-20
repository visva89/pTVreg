function [Knots_n] = refine_linear_grid_2d_v2(Knots, old_spacing, old_vsz, new_spacing, new_vsz, varargin)
    %[Knots_n] = refine_linear_grid_3d(Knots, old_spacing, ds, volsz,
    %  {upsampling_type}
    Nd = size(Knots, 4);
    
    upsampling_type = 'sample_std';
    if nargin >= 6
        upsampling_type = varargin{1};
    end
    
    ksz_new = ceil(new_vsz(1:Nd) ./ new_spacing(1:Nd)) + 1;
    Kn = zeros([ksz_new, Nd]);
    interp_type = 0;
    tmp = cat(3, imresize_my(Knots(:,:,1), ksz_new, interp_type), ...
                 imresize_my(Knots(:,:,2), ksz_new, interp_type));
    Kn = tmp;
    if strcmp(upsampling_type, 'variation')
        Tmin = linear_disp_2d(squeeze(Knots), old_vsz(1:Nd), old_spacing(1:Nd));
        Tmin_u = cat(3, imresize_my(Tmin(:,:, 1), new_vsz, 0), ...
                        imresize_my(Tmin(:,:, 2), new_vsz, 0));
        objf = @(x) align_knots(x, Tmin_u, new_vsz, [ksz_new, Nd], new_spacing(1:Nd));
        uopt = []; 
        uopt.method = 'lbfgs'; 
        uopt.MaxIter = 30; 
        uopt.method = 'cg'; 
        uopt.MaxIter = 50; 
        uopt.Corr=35; 
        uopt.Display = 'off';
        uopt.LS_type = 0; uopt.LS_init = 8;
        K2 = minFunc(objf, Kn(:), uopt);
        Knots_n = reshape(K2, [ksz_new, Nd]);
    end
end

function [f, gr] = align_knots(K, T, szv, szk, grid_spacing)
    K = reshape(K, szk);
    Kx = linear_disp_2d(K, szv, grid_spacing);
    df = Kx - T;
    f = sum(df(:).^2)/2;
    [gr1, gr2] = linear_partial_conv_2d(df(:,:, 1), df(:,:, 2), ...
                     size(K), grid_spacing); 
    gr = [gr1(:); gr2(:)];
end
