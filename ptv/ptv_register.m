function [voldef, Tmin_out, Kmin_out, varargout] = ptv_register(volmov, volfix, opts)
% `voldef, Tmin_out, Kmin_out, [itinfos] = ptv_register(volmov, volfix, opts)`
% 
% ### Input:
% 
%   `volmov`: image or array of movinv images that will be registered
%   
%   `volfix`: empty set or single reference image / target onto which moving
%           images are registered. Can be [] only in groupwise registration
%           with nuclear metric
%           
%   `opts`: configuration parameters of registration. Accepts following
%           fields:
%           
% ### Returns:
%   `voldef`: warped moving images (volmov), i.e. voldef = imdeform(volmov, Tmin_out)
%   
%   `Tmin_out`: estimated DISPLACEMENTS for each image in physical units,
%   specified by opts.pix_resolution.
%   
%   `Kmin_out`: parameters of displacement fields (Knots ofdisplacements). *INTERNAL*
%   
%   `itinfos`: estimates and optimization trace for each pyramid level
% 
%   We use the following array layot:
%   
%   `volmov:       sz1 - sz2 - sz3 - Nch - Nimgs`
%   
%   `Tmin_out:     sz1 - sz2 - sz3 - Nd  - Nimgs`
%   
% For 2D registration sz3=1, Nd=2, and Nd=3 for 3D
% registration. Nimgs is the number of images, each image can have Nch
% channels, which means that each displacement field will align all
% channels of the corresponding image simultaneously.
%       
% ALL input (including parameters) are double real valued arrays.
% 
% Parameters that might behave differently in the following versions are
% marked as *INTERNAL*.
% 
% *INTERNAL*:   vol_grads:  sz1 - sz2 - sz3 - Nch - Nimgs - Nd
% 
% ### `opts` description:
% 
% `pix_resolution`: physical resolution of voxel array of size Nd,
%   
% *DEFAULT*:[1,1,1]
% 
% `nlvl`: number of pyramid levels >= 1
%       
% *DEFAULT*: determined using the size of the input
% 
% `k_down`: downscaling factor for pyramid. Usually value of 0.5 is used.
% 
% *DEFAULT*: 0.7
% 
% `grid_spacing`: gap in pixels between knots that are used to parametrize
% displacements. Array of integers of size Nd
% 
% *DEFAULT*: [4,4,4]
% 
% `cp_refinements`: after finishing registration with grid_spacing we
% subdivide knot spacing cp_refinements times. Used for fine tuning, try
% to avoid.
% 
% *DEFAULT*: 0
% 
% `interp_type`: 0 - linear interpolation of image, 1 - cubic. Linear is more
% optimized
% 
% *DEFAULT*: 0
% 
% `metric`: image dissimilarity metric. Possible values
% 
% * 'ssd': sum of squared differences ||x-y||_2^2
% 
% * 'sad': sum of absolute differences ||x-y||_1
% 
% * 'loc_cc_fftn': local correlation coefficient
% 
% * *INTERNAL* :'loc_cc_fftn_single', 'loc_cc_fftn_gpu', 'loc_cc_fftn_gpu_single'
% 
% * 'nuclear': nuclear (PCA) groupwise metric
% 
% * 'local_nuclear'
% 
% * 'ngf' : normalied gradients field
% 
% *DEFAULT*: 'ssd'
% 
% `local_nuclear_patch_size`: ...
% 
% *DEFAULT*: 10
% 
% `nuclear_centering type`: for 'nuclear' and 'local_nuclear' metric choose
% patch centering type (options 0, 3 are the most reasonable):
% 
% * '0': no centering
% 
% * '1': average over dimensions 1,2,3 (spatial)
% 
% * '2': average over all dimensions 1,2,3,4,5
% 
% * '3': average over samples, dimensions 4,5 
% 
% * '4': 1 then 2
% 
% *DEFAULT*: 0
% 
% `metric_param`: used for 'loc_cc_fftn*' metrics, is the sigma of Gaussian
% weighting kernel (in physical units). For local_nuclear is the spatial size of nonoverlapping. patch Array of size Nd
% 
% *DEFAULT*: 7, but you should in practice use smaller value 
% 
% `ngf_eta` : NGF safeguard
% 
% *DEFAULT*: 0.01
% 
% `scale_metric_param`: *INTERNAL* should we downscale sigma?
% 
% *DEFAULT*: true
% 
% `loc_cc_approximate`: flag if we should use fast (approximate) formula for
% the gradient of 'loc_cc_fftn*' metric. Use only for huge images.
% 
% *DEFAULT*: false
% 
% `loc_cc_abs`: flag if we should use abs value of correlation coefficient in 'loc_cc_fftn*' metrics.
% Works well for contrast inversions
% 
% *DEFAULT*: false
% 
% `singular_coefs`: list of coefficients (of size Nimgs) for singular values weighting when
% using nuclear metric. Use custom values only if you know what you are
% doing. Advise: set first coefficient to zero, when performing groupwise 
% registation without target, otherwise algorithm will try to compress
% high intensity regions, since they increase largest singular value.
% 
% *DEFAULT*: [0, 1, 1, ..., 1]
% 
% `spline_order`: controls type of displacement parametrization:
% * 1 -- using linear interpolation (fastest and most reliable)
% * 3 -- cubic interpolation
% * 3.5 -- cubic with fractional knots *INTERNAL*
% * -1 -- translation motion *INTERNAL*
% * -2 -- rigid motion *INTERNAL*
% * -3 -- rigid + scaling *INTERNAL*
% * -4 -- affine *INTERNAL*
% 
% please avoid using values other than 1,3
% 
% *DEFAULT*: 1
% 
% `isoTV`: isotropic (vectorial) TV regularization of displacements
% 
% *DEFAULT*: 0
% 
% `max_iters`: max number of iterations at each pyramid level
% 
% *DEFAULT*: 100
% 
% `display`: 'iter' or 'off' ? display output of minFunc
% 
% *DEFAULT*: 'off'
% 
% `mean_penalty`: coefficient that forces displacement to be 'centered' 
% across the images. Needed when the target is not fixed.
% 
% `fixed_mask`: specify pixels that should be used to evaluate image 
% dissimilarity metric.
% 
% *DEFAULT*: []
% 
% `border_mask`: number of voxels around the borders that are not used in
% image dissimilarity metric, combined with fixed mask. Needed to avoid
% image extrapolation artefacts.
% 
% *DEFAULT*: 3
% 
% #### FOLLOWING ARE *INTERNAL* parameters
% 
% `fine_pyramid`: *INTERNAL* use different downscaling procedure to
% construct pyramid.
% 
% *DEFAULT*: false
% 
% `nuclear_rescale_strategy`: *INTERNAL*, nuclear metric with pyramids is
% hard...
% 
% `nuclear_coef`: *INTERNAL* image dissimilarity metric weight, can be only
% used with nuclear metric, introduced because of scaling experiments
% 
% *DEFAULT*: 1
% 
% `moving_mask`: *INTERNAL* specify pixels that should be warped and used 
% to evaluate image dissimilarity metric.
% 
% *DEFAULT*: []
% 
% `DiLj`: i-th order spatial drivative, x^j norm, includes D1L1, D2L1, D1L2, D2L2. 
% 
% *DEFAULT*: 0
% 
% `T_DiLj`: i-th order temporal drivative, x^j norm, includes T_D1L1, T_D2L1, T_D1L2, T_D2L2
% 
% *DEFAULT*: 0
% 
% `D1Lp`: nonconvex prior with value p = opts.spat_reg_p_val
% 
% `D2Lp`: nonconvex prior with value p = opts.spat_reg_p_val2
% 
% `check_gradients`: {false, true, #} numerically check # of derivatives
% 
% `regularize_directly`: bool
% 
% false: knots are regularized
% true: T(knots) regularized
% Probably should get rid of it.
% 
% *DEFAULT*: false
% 
% `folding_penalty`: coefficient of very crude approximation for folding penalty
% 
% *DEFAULT*: 0
% 
% `jac_reg`: regularization weight of Jacobian of transformation. Penalizes if Jacobian >= 4 or <= 0.2
% 
% *DEFAULT*: 0
% 
% `csqrt`: smoothing of TV norm `|x|\approx sqrt(x^2+csqrt)`
% 
% *DEFAULT*: 5e-3
% 
% `opt_method`: optimization method from minFunc 
% 
% *DEFAULT*: lbfgs
% 
% `img_edge_prior_strength`: puts a prior on displacement edges based on image edges. Doesn't seem to work. 
% 
% *DEFAULT*: 0
% 
% #### Segmentation parameters
% `mov_segm`: segmentation mask of moving images
% 
% `segm_val1`: average image intensity at locations where mov_segm=1
% 
% `segm_val0`: average image intensity at locations where mov_segm=0
% 
% `segm_koef`: weigh of the segmentation cost


% Author: Valery Vishnevskiy valera.vishnevskiy@yandex.ru
% ETH Zurich, CMR, CAiM
% 26.02.2018

if nargout >= 4
    do_itinfos = true;
else
    do_itinfos = false;
end
[imsz, Nd, Nch, Nimgs, nlvl, cp_refinements, interp_type, metric, ...
    scale_metric_param, pix_resolution, metric_param, grid_spacing, ...
    max_iters, opt_method, display, isoTV, D1L2, D2L2, D2L1, D1L1, D1Lp, spat_reg_p_val, ...
    D2Lp, spat_reg_p_val2, ...
    T_D1L2, T_D2L2, T_D2L1, T_D1L1, border_mask, fixed_mask, moving_mask, csqrt, ...
    fold_k, k_down, fine_pyramid, mean_penalty, loc_cc_approximate, nuclear_coef, ...
    singular_coefs, nuclear_resc_strategy, mov_segm, segm_val1, segm_val0, segm_koef, ...
    K_ord, check_gradients, regul_displs_directly, ngf_eta, jac_reg, img_edge_prior_strength, local_nuclear_patch_size, ...
    loc_cc_abs, nuclear_centering] ...
    = ptv_process_input(volmov, volfix, opts);

internal_dtype = 'CPU_double';
% internal_dtype = 'CPU_single';
% internal_dtype = 'GPU_single';
% internal_dtype = 'GPU_double';
volmov = convert_to_dtype(volmov, internal_dtype);
volfix = convert_to_dtype(volfix, internal_dtype);

gp_volfix = cell(nlvl, 1);
gp_volmov = cell(nlvl, 1);
gp_mask = cell(nlvl, 1);
gp_mask_moving = cell(nlvl, 1);
gp_mov_segm = cell(nlvl, 1);
grid_spacings = zeros(nlvl, 3);
pix_resolutions = zeros(nlvl, 3);
ds = zeros(nlvl, 3);
grid_spacings(1, :) = grid_spacing;

itinfos = {};

force_isotropic = false;

[gp_volmov, ds, pix_resolutions] = ptv_create_pyramid(volmov, nlvl, pix_resolution, force_isotropic, k_down, 0, fine_pyramid);
if ~isempty(volfix)
    [gp_volfix, ~, ~] = ptv_create_pyramid(volfix, nlvl, pix_resolution, force_isotropic, k_down, 0, fine_pyramid);
end
if ~isempty(mov_segm)
    [gp_mov_segm, ~,~] = ptv_create_pyramid(mov_segm, nlvl, pix_resolution, force_isotropic, k_down, 0, fine_pyramid);
end
if ~isempty(fixed_mask)
    [gp_mask, ~, ~] = ptv_create_pyramid(fixed_mask, nlvl, pix_resolution, force_isotropic, k_down, 0, fine_pyramid);
end
if ~isempty(moving_mask)
    [gp_mask_moving, ~, ~] = ptv_create_pyramid(moving_mask, nlvl, pix_resolution, force_isotropic, k_down, 0, fine_pyramid);
end

% voldef = cell(nlvl, 1);
% Tmin_out = cell(nlvl, 1);
% Kmin_out = cell(nlvl, 1);
finest_pix_sp = pix_resolutions(1, :);
finest_grid_sp = grid_spacing / (2^cp_refinements);
finest_grid_sz = ptv_get_grid_size(imsz, finest_grid_sp, K_ord);

nuclear_scales = calculate_nuclear_coefficients(gp_volfix, gp_volmov, singular_coefs, nuclear_resc_strategy);


for i = 1 : nlvl + cp_refinements
    if i <= nlvl
        idx_pyr = nlvl + 1 - i;
        cur_pix_resolution = pix_resolutions(idx_pyr, :);
        cur_grid_spacing = grid_spacing;
        volfix = gp_volfix{idx_pyr};
        volmov = gp_volmov{idx_pyr};
        cur_fixed_mask = gp_mask{idx_pyr};
        cur_mov_segm = gp_mov_segm{idx_pyr};
        cur_max_iters = max_iters(min(i, numel(max_iters)));
        cur_moving_mask = gp_mask_moving{idx_pyr};
        imsz_cur = size(volmov(:,:,:, 1));
        ksz = ptv_get_grid_size(imsz_cur, grid_spacing, K_ord);
        nuclear_coef_cur = nuclear_coef * nuclear_scales(idx_pyr);
        if i == 1
            if K_ord == -1 || K_ord == -2 || K_ord == -3 || K_ord == -4
                Knots = 0 * zeros([ksz, 1, Nimgs]);
            else
                Knots = 0 * zeros([ksz, Nd, Nimgs]);
            end
        else
            Knots = ptv_upsample_knots(Kmin, imsz_prev, grid_spacing, imsz_cur, grid_spacing, k_down, 'variational', K_ord, Nd);
        end
    else
        grid_spacing_old = cur_grid_spacing;
        cur_grid_spacing = round(cur_grid_spacing / 2);
        Knots = ptv_upsample_knots(Kmin, imsz_prev, grid_spacing_old, imsz_cur, cur_grid_spacing, k_down, 'variational', K_ord, Nd);
    end
    
    metric_param_pix = [];
    if strcmp(metric, 'loc_cc_fftn_gpu') || strcmp(metric, 'loc_cc_fftn_gpu_single') || strcmp(metric, 'loc_cc_fftn')|| strcmp(metric, 'loc_cc_fftn_single')
        if scale_metric_param
            metric_param_pix = metric_param ./ cur_pix_resolution;
        else
            metric_param_pix = metric_param ./ pix_resolution;
        end
    end

    [Tmin, Kmin, fmin, fData, fReg, outp] = int_register(volmov, volfix, cur_fixed_mask, cur_moving_mask, isoTV, D1L1, D1L2, D2L1, D2L2, Knots, ...
                        T_D1L1, T_D1L2, T_D2L1, T_D2L2, D1Lp, spat_reg_p_val, D2Lp, spat_reg_p_val2, ...
                        cur_grid_spacing, cur_pix_resolution, interp_type, metric, loc_cc_approximate, cur_max_iters, metric_param_pix, display, opt_method, ...
                        nuclear_coef_cur, singular_coefs, ...
                        internal_dtype, fold_k, K_ord, cur_mov_segm, segm_val1, segm_val0, segm_koef, csqrt, check_gradients, ...
                        regul_displs_directly, Nd, mean_penalty, ngf_eta, jac_reg, img_edge_prior_strength, local_nuclear_patch_size, ...
                        loc_cc_abs, nuclear_centering);
    fprintf('fmin = %e (%d)\n', fmin, nlvl+1-i);
    
    Tmin = convert_to_dtype(Tmin, internal_dtype);
    volmov = convert_to_dtype(volmov, internal_dtype);
    
    Tmin_pix = conv_3d_T_from_phys_to_pix(Tmin, cur_pix_resolution);
    
    voldef = ptv_deform(volmov, Tmin_pix, interp_type);
    Tmin_out = Tmin;
    Kmin_out = Kmin;
    if do_itinfos
        itinfos{i} = [];
        itinfos{i}.outp = outp;
        itinfos{i}.fData = fData;
        itinfos{i}.fReg = fReg;
        itinfos{i}.fmin = fmin;
        itinfos{i}.Tmin = Tmin;
        itinfos{i}.Kmin = Kmin;
        itinfos{i}.voldef = voldef;
    end
    
    imsz_prev = imsz_cur;
end
if do_itinfos
    varargout{1} = itinfos;
end
end

function n_coefs = calculate_nuclear_coefficients(gp_volfix, gp_volmov, singular_coefs, nuclear_resc_strategy)
    if numel(gp_volmov) == 1
        n_coefs = 1;
        return;
    end
    if strcmp(nuclear_resc_strategy, 'linear')
        nv = zeros(numel(gp_volmov), 1);
        np = zeros(numel(gp_volmov), 1);
        for i = 1 : numel(gp_volmov)
            sc = singular_coefs;
            for ic = 1 : size(gp_volmov{i}, 4)
                t = gp_volmov{i}(:,:,:, ic, :);
                if ~isempty(gp_volfix{i})
                    t = cat(5, t, gp_volfix{i}(:,:,:, ic, :));
    %                 sc = [0; 1; sc(2:end)'];
                    if numel(sc) > 1
                        sc = [fl(sc(1:end)); sc(end)];
                    end
                end
                t = reshape(t, [], size(t, 5));
                s = svd(t, 'econ');
                if numel(sc) > 1
                    sc = sc(1:numel(s));
                end
                nv(i) = nv(i) + sum(s(:) .* sc(:));
            end
            np(i) = numel(gp_volmov{i});
        end
        nv = nv / (nv(1) + 1e-6);
        n_coefs = 1 ./ (nv + 1e-6);
%         nv

        if true
    %         n_coefs
            ps = polyfit(np, nv, 1);
            n_coefs_l = ps(1) * np + ps(2);
    %         hold off;
    %         plot(np, nv, 'rx-'); 
    %         hold on;
    %         plot(np, n_coefs_l, 'bx-'); 
            
            n_coefs = 1./(abs(n_coefs_l) + 1e-6);
            n_coefs = n_coefs / n_coefs(1);
    %         pause;
        end
    elseif strcmp(nuclear_resc_strategy, 'sqrt')
        n_coefs = ones(numel(gp_volmov), 1);
        for i = 1 : numel(gp_volmov)
            n_coefs(i) = sqrt(numel(gp_volmov{1}) / numel(gp_volmov{i}) );
        end
    end
end

function [Tmin, Kmin, fmin, fData, fReg, outp] = int_register(volmov, volfix, cur_fixed_mask, cur_moving_mask, isoTV, D1L1, D1L2, D2L1, D2L2, Knots0, ...
                        T_D1L1, T_D1L2, T_D2L1, T_D2L2, D1Lp, spat_reg_p_val, D2Lp, spat_reg_p_val2, ......
                        cur_grid_spacing, cur_pix_resolution, interp_type, metric, loc_cc_approximate, max_iters, metric_param, display, opt_method, ...
                        nuclear_coef, singular_coefs, ...
                        internal_dtype, fold_k, K_ord, cur_mov_segm, segm_val1, segm_val0, segm_koef, csqrt, check_gradients, ...
                        regul_displs_directly, Nd, mean_penalty, ngf_eta, jac_reg, img_edge_prior_strength, local_nuclear_patch_size, ...
                        loc_cc_abs, nuclear_centering)
    ksz = [size(Knots0, 1), size(Knots0, 2), size(Knots0, 3)];
    [imsz, ~, Nch, Nimgs] = ptv_get_sizes_from_volsz(size(volmov));
    A1 = [];
    A2 = [];
    if regul_displs_directly
        if D1L1>0 || D1L2 > 0
            A1 = generate_first_cyc_difference_matrix_for_image(imsz, 1, cur_pix_resolution);
        end
        if D2L1>0 || D2L2 > 0
            A2 = generate_first_difference_matrix_for_image(imsz, 2, cur_pix_resolution);
        end
    else
        if D1L1>0 || D1L2 > 0
            A1 = generate_first_cyc_difference_matrix_for_image(ksz, 1, cur_pix_resolution .* cur_grid_spacing);
        end
        if D2L1>0 || D2L2 > 0
            A2 = generate_first_difference_matrix_for_image(ksz, 2, cur_pix_resolution .* cur_grid_spacing);        
        end
    end
    DT1 = [];
    DT2 = [];
    if Nimgs > 1 
        e = ones(Nimgs, 1);
        DT1 = spdiags([e, -e], 0:1, Nimgs, Nimgs);
        DT1(Nimgs, 1) = -1;
        DT2 = DT1*DT1;
        DT2 = DT2(1:end-2, :);
        DT1 = DT1(1:end-1, :);
    end
    
    cache = []; 
    if strcmp(metric, 'loc_cc_fftn_gpu') || strcmp(metric, 'loc_cc_fftn_gpu_single') || strcmp(metric, 'loc_cc_fftn') || strcmp(metric, 'loc_cc_fftn_single')
        cache = cell(Nch, 1);
        for ic = 1 : Nch
            cache{ic} = create_loc_cc_fftn_cache(metric, metric_param, ...
                volmov(:,:,:, ic, 1), volfix(:,:,:, ic, 1), ...
                internal_dtype, cur_fixed_mask, 1e-4, loc_cc_approximate);
            cache{ic}.loc_cc_abs = loc_cc_abs;
        end
    end
    if strcmp(metric, 'ngf')
        cache = cell(Nch, 1);
        for ic = 1 : Nch
            cache{ic} = create_ngf_cache(metric, ngf_eta, volmov(:,:,:, ic, 1), volfix(:,:,:, ic, 1), cur_pix_resolution, internal_dtype, cur_fixed_mask);
        end
    end
    
    volmov = convert_to_dtype(volmov, internal_dtype);
    volfix = convert_to_dtype(volfix, internal_dtype);
    
    if K_ord == 3.5
        KT = create_3d_image_upsample_matrix(ksz, [size(volmov,1),size(volmov,2), size(volmov,3)]);
    else
        KT = [];
    end
    
    if img_edge_prior_strength > 0
        if Nd == 2
            ds_vfix = imresize(mean(volfix, 4), [ksz(1), ksz(2)]);
            [fixgrad1, fixgrad2] = my_gradient(ds_vfix, cur_pix_resolution(1:Nd));
            edge_prior = sqrt(fixgrad1.^2 + fixgrad2.^2) * img_edge_prior_strength;
        elseif Nd == 3
            ds_vfix = volresize(mean(volfix, 4), [ksz(1), ksz(2), ksz(3)]);
            [fixgrad1, fixgrad2, fixgrad3] = my_gradient(ds_vfix, cur_pix_resolution);
            edge_prior = sqrt(fixgrad1.^2 + fixgrad2.^2 + fixgrad3.^2) * img_edge_prior_strength;
        end
    else
        edge_prior =  [];
    end
    
    objf = @(X) ptv_full_grad(volmov, volfix, X, size(Knots0), ...
        isoTV, D1L1, D1L2, D2L1, D2L2, ...
        regul_displs_directly, csqrt, ...
        A1, A2, mean_penalty,...
        T_D1L1, T_D1L2, T_D2L1, T_D2L2, DT1, DT2, D1Lp, spat_reg_p_val,...
        D2Lp, spat_reg_p_val2, ...
        cur_grid_spacing, cur_pix_resolution, interp_type, metric, ...
        nuclear_coef, singular_coefs, ...
        cur_fixed_mask, cur_moving_mask, cache,  ...
        internal_dtype, fold_k, K_ord, KT,...
        cur_mov_segm, segm_val1, segm_val0, segm_koef, Nd, jac_reg, ...
        edge_prior, local_nuclear_patch_size, nuclear_centering);
    
    options = [];
    options.display = display;
    % options.LS_init = 4;
    options.MaxIter = max_iters;
    options.MaxFunEvals = round(max_iters * 1.3);
    options.Method = opt_method;

    options.DerivativeCheck = 'off';
    options.Damped = 0;
    options.LS_type = 0; options.LS_init = 8; %
%     options.LS_type = 0; options.LS_init = 2; %
%     options.LS_type = 1; options.LS_init = 2; %
    options.optTol = 1e-8;
    options.progTol = 1e-4 / max(cur_pix_resolution(1:Nd));
    
    options.Corr = 85; 
    if numel(Knots0) > (100^3)
        options.Corr = 30; 
%         options.Corr
    end
%     options.progTol = 1e-30;
%     options.optTol = 1e-30;
    
    options.A_step_length = min(cur_pix_resolution)/2.4;
    
    if K_ord > 0
        options.cap_values = max(imsz(1:Nd)/6 .* cur_pix_resolution(1:Nd));
    end
    if strcmp(metric, 'loc_cc_fftn_gpu_single')
        options.progTol = 1e-10;
    end
    if K_ord == -3 || K_ord == -2 || K_ord == -4
        options.progTol = 1e-8;
        caps = ones(size(Knots0));
        caps(1:Nd, :, :, :, :) = max(imsz(1:Nd)/5 .* cur_pix_resolution(1:Nd));
        caps(Nd+1:end, :, :, :, :) = 0.01;
        options.cap_values = caps(:);
%         options.cap_values = [];
    end
    if check_gradients 
        rng(32423);
        TT = 5*(rand(size(Knots0(:))) - 0.5);
        idxs = randperm(numel(TT));
        if isnumeric(check_gradients)
            idxs = idxs(1:min(check_gradients, numel(TT)));
        else
            idxs = idxs(1:min(40, numel(TT)));
        end
%         num_step = 2e-5 * min(cur_pix_resolution(1:Nd));
        num_step = 2 * sqrt(1e-10)*(1+norm(TT(:)));
%         num_step = 1e-6;

        gnn = numerical_grad(objf, TT, num_step, idxs);
        [~, gmy] = objf(TT);
        subplot(121)
        hold off
        plot(gnn(idxs), gmy(idxs), 'rx');
        fprintf('AbsNorm %e,  RelNorm %e\n', norm(gnn(idxs) - gmy(idxs)), norm(gnn(idxs) - gmy(idxs)) / norm(gnn(idxs)));
        hold on;
        plot([min(gnn(:)), max(gnn(:))], [min(gnn(:)), max(gnn(:))],'y--', 'LineWidth', 2)
        subplot(122)
        gr_d = gnn(idxs)'./gmy(idxs)';
        plot(sort(gr_d));
        
%         tmpi = reshape(gmy, size(Knots0));
%         tmpn = reshape(gnn, size(Knots0));
%         tmpi = tmpi(:,:, round(end/2), 1);
%         tmpn = tmpn(:,:, round(end/2), 1);
%         tmp = abs(tmpi - tmpn);
%         tmp(tmpn == 0) = NaN;
%         imagesc(tmp); colorbar;
%         imagesc(abs(tmpi - tmpn).*(tmpn~=0) + 1 .* (tmpn~=0));
        pause(2);
    end

    [xmin, fmin, ~, outp] = minFuncJoker(objf, Knots0(:), options);
    [fmin, ~, fData, fReg] = objf(xmin);
    Kmin = reshape(xmin, size(Knots0));
    Tmin = ptv_disp_from_knots(Kmin, [size(volmov,1), size(volmov,2), size(volmov,3)], cur_grid_spacing, K_ord, Nd, KT);
end


function [xmin, fmin, v3, outp] = minFuncJoker(objf, x0, options)
    Method = getoptions(options, 'Method');
    if strcmp(Method, 'lbfgs+cg')
        options.Method = 'lbfgs';
        [xmin, fmin, v3, outp] = minFunc(objf, x0(:), options);
        options.Method = 'cg';
        [xmin, fmin, v3, outp] = minFunc(objf, xmin(:), options);
    elseif strcmp(Method, 'lbfgs+csd')
        options.Method = 'lbfgs';
        [xmin, fmin, v3, outp] = minFunc(objf, x0(:), options);
        options.Method = 'csd';
        [xmin, fmin, v3, outp] = minFunc(objf, xmin(:), options);
    elseif strcmp(Method, 'adam')
        v3=0;
        outp = 0;
        sOpt = optimset('fmin_adam');
        sOpt.GradObj = 'on';
        sOpt.MaxFunEvals = options.MaxFunEvals;
        sOpt.MaxIter = options.MaxIter;
        sOpt.Display = 'off';
        step_length = options.A_step_length;
        [xmin, fmin] = fmin_adam(objf, x0(:), step_length, [], [], [], 1, sOpt);
    else
        [xmin, fmin, v3, outp] = minFunc(objf, x0(:), options);
    end
end