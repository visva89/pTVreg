function [imsz, Nd, Nch, Nimgs, nlvl, cp_refinements, interp_type, metric, ...
    scale_metric_param, pix_resolution, metric_param, grid_spacing, ...
    max_iters, opt_method, display, isoTV, D1L2, D2L2, D2L1, D1L1, D1Lp, spat_reg_p_val, ...
    D2Lp, spat_reg_p_val2, ...
    T_D1L2, T_D2L2, T_D2L1, T_D1L1, border_mask, fixed_mask, moving_mask, csqrt, ...
    fold_k, k_down, fine_pyramid, mean_penalty, loc_cc_approximate, nuclear_coef, ...
    singular_coefs, nuclear_resc_strategy, mov_segm, segm_val1, segm_val0, segm_koef, ...
    K_ord, check_gradients, regul_displs_directly, ngf_eta, jac_reg, img_edge_prior_strength, local_nuclear_patch_size,...
    loc_cc_abs, nuclear_centering] ...
    = ptv_process_input(volmov, volfix, opts)

try
    q = ones(3,1) .* ones(1, 3);
catch
    error('Broadcasting is not supported, update Matlab');
end

check_names(opts);

szmov = size(volmov);
szfix = size(volfix);
[imsz, Nd, Nch, Nimgs] = ptv_get_sizes_from_volsz(size(volmov));

if ~isempty(volfix) && any(szmov(1:Nd) ~= szfix(1:Nd))
    error('Sizes dont match');
end
if ndims(volmov) > 5
    error('volmov size should be sz1 - sz2 - sz3 - Nch - Nimgs')
end
if ndims(volfix) > 4
    error('volmov size should be sz1 - sz2 - sz3 - Nch')
end

if max(abs(volmov) > 5)
    warning('Image intensities seem to be unnormalized');
end

nlvl = getoptions(opts, 'nlvl', []);
cp_refinements = getoptions(opts, 'cp_refinements', 0);
interp_type = getoptions(opts, 'interp_type', 0);
metric = getoptions(opts, 'metric', 'ssd');
scale_metric_param = getoptions(opts, 'scale_metric_param', true);
pix_resolution = getoptions(opts, 'pix_resolution', [1,1,1]);
metric_param = getoptions(opts, 'metric_param', [7,7,7]);
grid_spacing = getoptions(opts, 'grid_spacing', [4,4,4]);
if numel(grid_spacing) == 1
    grid_spacing = [1,1,1] * grid_spacing;
end
if Nd == 2
    grid_spacing = [grid_spacing(1), grid_spacing(2), 1];
end
if numel(metric_param) == 1
    metric_param = [1,1,1] * metric_param;
end
if Nd == 2
    metric_param = [metric_param(1), metric_param(2), 1];
end
if numel(pix_resolution) == 1
    pix_resolution = [1,1,1] * pix_resolution;
end
if Nd == 2
    pix_resolution = [pix_resolution(1), pix_resolution(2), 1];
end
ngf_eta = getoptions(opts, 'ngf_eta', 1e-2);

max_iters = getoptions(opts, 'max_iters', 100);
opt_method = getoptions(opts, 'opt_method', 'lbfgs');
display = getoptions(opts, 'display', 'off');

local_nuclear_patch_size = getoptions(opts, 'local_nuclear_patch_size', 10);
if numel(local_nuclear_patch_size) == 1
    local_nuclear_patch_size = ones(1, Nd) * local_nuclear_patch_size;
else
    local_nuclear_patch_size = local_nuclear_patch_size(1:Nd);
end

isoTV = getoptions(opts, 'isoTV', 0.0);
D1L2 = getoptions(opts, 'D1L2', 0);
D2L2 = getoptions(opts, 'D2L2', 0);
D2L1 = getoptions(opts, 'D2L1', 0);
D1L1 = getoptions(opts, 'D1L1', 0);
D1Lp = getoptions(opts, 'D1Lp', 0);
spat_reg_p_val = getoptions(opts, 'spat_reg_p_val', 0.7);

D2Lp = getoptions(opts, 'D2Lp', 0);
spat_reg_p_val2 = getoptions(opts, 'spat_reg_p_val2', 0.7);

img_edge_prior_strength = getoptions(opts, 'img_edge_prior_strength', 0);

jac_reg = getoptions(opts, 'jac_reg', 0);

T_D1L2 = getoptions(opts, 'T_D1L2', 0);
T_D2L2 = getoptions(opts, 'T_D2L2', 0);
T_D2L1 = getoptions(opts, 'T_D2L1', 0);
T_D1L1 = getoptions(opts, 'T_D1L1', 0);
border_mask = getoptions(opts, 'border_mask', 3);

fixed_mask = getoptions(opts, 'fixed_mask', []);
moving_mask = getoptions(opts, 'moving_mask', []);
csqrt = getoptions(opts, 'csqrt', 5e-3);
fold_k = getoptions(opts, 'folding_penalty', 0.00);
k_down = getoptions(opts, 'k_down', 0.7);
fine_pyramid = getoptions(opts, 'fine_pyramid', false);
mean_penalty = getoptions(opts, 'mean_penalty', 0);
if mean_penalty > 0 && ~isempty(volfix)
    warning('Mean penalty is nonzero, but fixed target is given. Try setting mean penalty to 0');
end

loc_cc_approximate = getoptions(opts, 'loc_cc_approximate', false);

nuclear_centering = getoptions(opts, 'nuclear_centering', 0);
loc_cc_abs = getoptions(opts, 'loc_cc_abs', false);

nuclear_coef = getoptions(opts, 'nuclear_coef', 1);
singular_coefs = getoptions(opts, 'singular_coefs', []);
if isempty(singular_coefs)
    if isempty(volfix)
%         singular_coefs = sqrt(1:Nimgs);
        singular_coefs = ones(1, Nimgs);
        singular_coefs(1) = 0;
    else
        singular_coefs = ones(1, Nimgs+1);
        singular_coefs(1) = 0;
%         singular_coefs = sqrt(1:(Nimgs+1));
    end
end
% singular_coefs = getoptions(opts, 'singular_coefs', [0, sqrt(2:Nimgs)]);
% singular_coefs = singular_coefs(:);
nuclear_resc_strategy = getoptions(opts, 'nuclear_rescale_strategy', 'linear');
% sqrt
% recalc_back
% recalc_forward
% no_scale
% linear

mov_segm = getoptions(opts, 'mov_segm', []);
segm_val1 = getoptions(opts, 'segm_val1', 1);
segm_val0 = getoptions(opts, 'segm_val0', 0);
segm_koef = getoptions(opts, 'segm_koef', 0);
if ~isempty(mov_segm) && segm_koef > 0 && Nch > 1
    error('Segmentation is possible for a pair of  single channel images (size(volmov, 4) = 1, size(volmov, 5) = 1, volfix ~= [])');
end

K_ord = getoptions(opts, 'spline_order', 1);
check_gradients = getoptions(opts, 'check_gradients', false);
regul_displs_directly = getoptions(opts, 'regularize_directly', false);

if isempty(nlvl) 
%     nlvl = floor(abs(log(min(imsz(1:Nd)) / 4)) / abs(log(k_down)));
%     nlvl = floor(abs(log(min(imsz(1:Nd)) / max(4, max(grid_spacing)) )) / abs(log(k_down)));
%     imsz
%     grid_spacing
    nlvl = min(  floor(abs(log(  imsz(1:Nd) ./ max(4, grid_spacing(1:Nd)) )) / abs(log(k_down))));
end
if ~isempty(border_mask) && border_mask > 0
    bmask = ones(imsz);
    bmask(1:border_mask, :, :) = 0; bmask(end-border_mask+1:end, :, :) = 0;
    bmask(:, 1:border_mask, :) = 0; bmask(:, end-border_mask+1:end, :) = 0;
    if Nd == 3
        bmask(:, :, 1:border_mask) = 0; bmask(:, :, end-border_mask+1:end) = 0;
    end
    if isempty(fixed_mask)
        fixed_mask = bmask;
    else
        fixed_mask = fixed_mask .* bmask;
    end
end

if strcmp(metric, 'loc_cc_fftn_gpu') || strcmp(metric, 'loc_cc_fftn_gpu_single')
    try 
        q = gpuArray(1) * 2;
    catch
        warning('Cannot use GPU, fallback to CPU');
        if strcmp(metric, 'loc_cc_fftn_gpu')
            metric = 'loc_cc_fftn';
        elseif strcmp(metric,  'loc_cc_fftn_gpu_single')
            metric = 'loc_cc_fftn_single';
        end
    end
end

end

function check_names(opts)
    known_inputs = { ...
        'nlvl',...
        'cp_refinements', ...
        'interp_type',...
        'metric',...
        'scale_metric_param',...
        'pix_resolution',...
        'metric_param',...
        'grid_spacing',...
        'max_iters',...
        'opt_method',...
        'display',...
        'isoTV',...
        'D1L2',...
        'D1L1',...
        'D2L2',...
        'D2L1',...
        'D1Lp',...
        'spat_reg_p_val',...
        'T_D1L2',...
        'T_D1L1',...
        'T_D2L2',...
        'T_D2L1',...
        'border_mask',...
        'fixed_mask',...
        'moving_mask',...
        'csqrt',...
        'folding_penalty',...
        'k_down',...
        'fine_pyramid',...
        'mean_penalty',...
        'loc_cc_approximate',...
        'nuclear_coef',...
        'singular_coefs',...
        'nuclear_rescale_strategy',...
        'mov_segm',...
        'segm_val1',...
        'segm_val0',...
        'segm_koef',...
        'spline_order',...
        'check_gradients',...
        'regularize_directly',...
        'jac_reg', ...
        'ngf_eta', ...
        'img_edge_prior_strength', ...
        'D2Lp', ...
        'spat_reg_p_val2', ...
        'local_nuclear_patch_size',...
        'loc_cc_abs',...
        'nuclear_centering'...
        };
    unrec = setdiff(fieldnames(opts), known_inputs);
    if ~isempty(unrec)
        fprintf('Unrecognized options:\n');
        for i = 1 : numel(unrec)
            fprintf('"%s"\n', unrec{i});
        end
        error('Unrecognize fields options found');
    end
end