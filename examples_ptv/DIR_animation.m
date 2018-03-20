addpath(genpath('../mutils/My/'));
addpath(genpath('../ptv'));
basepth = '../../data_prj/dir_dataset/DIR_files/';


TIME_e = zeros(2,2,2, 10); 
TRE_e = zeros(2,2,2, 10);

use_refinement = 0 : 1
resize = 1
fast_lcc = true

for idx = 8
    pts_struct = DIR_get_all_points_for_the_case(idx, basepth);
    [volmov, spc] = read_DIR_volume_4dCT(idx, 5, basepth);
    volmov = double(volmov);
    pts_mov = pts_struct.extreme.e;
    [volfix, spc] = read_DIR_volume_4dCT(idx, 0, basepth);
    volfix = double(volfix);
    pts_fix = pts_struct.extreme.b;

    volmov = img_thr(volmov, 80, 900, 1);
    volfix = img_thr(volfix, 80, 900, 1);
    
    % crop images 
    init_size = size(volmov);
    min_max1 = [ min(pts_mov, [], 1)', max(pts_mov, [], 1)'];
    min_max2 = [ min(pts_fix, [], 1)', max(pts_fix, [], 1)'];
    min_max = [ min(min_max1(:, 1), min_max2(:, 1)), max(min_max1(:, 2), min_max2(:, 2))];
    d = [10, 10, 5];
    crop_v = [ max(1, min_max(1,1) - d(1)), min(size(volmov, 1), min_max(1,2) + d(1)); ... 
               max(1, min_max(2,1) - d(2)), min(size(volmov, 2), min_max(2,2) + d(2)); ... 
               max(1, min_max(3,1) - d(3)), min(size(volmov, 3), min_max(3,2) + d(3));];
    volmov = crop_data(volmov, crop_v);
    volfix = crop_data(volfix, crop_v);

    spc_orig = spc;
    if resize
        bszv = size(volmov);
        spc_tmp = [1, 1, 1];
        volfix = volresize(volfix, round(bszv .* spc .* spc_tmp), 1);
        volmov = volresize(volmov, round(bszv .* spc .* spc_tmp), 1);
        spc = [1,1,1] ./ spc_tmp;
    end
    
    % configure registration
    opts = [];
    opts.loc_cc_approximate = fast_lcc;
    if use_refinement
        if resize
            opts.grid_spacing = [4, 4, 4]*2; 
        else
            opts.grid_spacing = [4, 4, 3]*2;  % grid spacing in pixels
        end
        opts.cp_refinements = 1;
    else
        if resize
            opts.grid_spacing = [4, 4, 4]; 
        else
            opts.grid_spacing = [4, 4, 3];  % grid spacing in pixels
        end
        opts.cp_refinements = 0;
    end
    opts.display = 'off';
    opts.k_down = 0.7;
    opts.interp_type = 0;
    opts.metric = 'loc_cc_fftn_gpu';
    opts.metric_param = [1,1,1] * 2.1;
    opts.scale_metric_param = true;
    opts.D1Lp = 0.15;
    opts.spat_reg_p_val = 0.75;

    opts.csqrt = 5e-3;
    opts.spline_order = 1;
    opts.border_mask = 5;
    opts.max_iters =  80;
    opts.check_gradients = 100*0;
    opts.pix_resolution = spc;

    timer = tic;
    [voldef, Tptv, Kptv] = ptv_register(volmov, volfix, opts);
    TIME_e(use_refinement+1, resize+1, fast_lcc+1, idx) = toc(timer);

    if resize
        Tptv_rsz = cat(4, volresize(Tptv(:,:,:,1), bszv), volresize(Tptv(:,:,:,2), bszv), volresize(Tptv(:,:,:,3), bszv));   
        voldef_rsz = volresize(voldef, bszv);
    else
        Tptv_rsz = Tptv;
    end
    [~, Tptv_rsz] = uncrop_data(voldef_rsz, Tptv_rsz, crop_v, init_size);
    % move points and measure TRE
    [pt_errs_phys, pts_moved_pix, TRE_phys, TREstd_phys] = DIR_movepoints(pts_mov, pts_fix, Tptv_rsz, spc_orig, []);
    TREs(idx) = mean(TRE_phys);

    TRE_e(use_refinement+1, resize+1, fast_lcc+1, idx) = mean(TRE_phys);
end
%%

imgs_exp = [];
Tpix = conv_3d_T_from_phys_to_pix(Tptv(:,:,:,:, :), opts.pix_resolution);

hold off;
imagesc(squeeze(volfix(:, round(end/2), :, :, 1))'); 
colormap gray;
daspect([1,1,1]);
hold on;
plot_wiremesh(permute(squeeze(Tpix(:, round(end/2), :, [3,2], 1))*0, [2,1,3]), 6, 'r-')

F = getframe;
imgs_exp = cat(4, imgs_exp, double(F.cdata));

i = 1;
hold off;
imagesc(squeeze(volmov(:, round(end/2), :, :, i))'); 
colormap gray;
daspect([1,1,1]);
hold on;
plot_wiremesh(permute(squeeze(Tpix(:, round(end/2), :, [3,2], i)), [2,1,3]), 6, 'r-')

F = getframe;
imgs_exp = cat(4, imgs_exp, double(F.cdata));

pause(0.1);
%%
ima = cat(3, squeeze(voldef(:, round(end/2), :))', squeeze(volfix(:, round(end/2), :))');
savegif('results/DIR_pw_track.gif', squeeze([imgs_exp]/250), 1/2);
savegif('results/DIR_pw_stab.gif', ima, 1/2);

    
    
