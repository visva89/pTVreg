addpath(genpath('../mutils/My/'));
addpath(genpath('../ptv'));

%%
basepth = '../../data_prj/dir_dataset/DIR_files/';

TRE = zeros(10,1);
TIME = zeros(10,1);
TREstd = zeros(10,1);
TREc = zeros(10, 3);
TREcstd = zeros(10, 3);
opts = [];
opts.grid_spacing = [4, 4, 3];  % grid spacing in pixels
opts.display = 'off';
opts.k_down = 0.7;
opts.interp_type = 0;
opts.metric = 'nuclear';
opts.max_iters =  10;
opts.max_iters = 110;
opts.check_gradients = 100*0;
opts.interp_type = 0;

opts.spline_order = 1;

% opts.singular_coefs = sqrt(1:6);
% opts.singular_coefs(1) = 0;
opts.spat_reg_p_val = 0.75;
opts.jac_reg = 10;

opts.D1Lp = 1e-5;
opts.D1Lp = 8e-6;
% opts.D1Lp = 3e-6*0;

% opts.D1Lp = 1e-4; opts.opt_method = 'adam'; % not distributed
opts.opt_method = 'lbfgs';
% opts.opt_method = 'adam';

opts.nlvl = [];

for idx = 8 %1:10
    pts_struct = DIR_get_all_points_for_the_case(idx, basepth);
    % read images
    [volmov, spc] = read_DIR_volume_4dCT(idx, 5, basepth);
    pts_mov = pts_struct.extreme.e;
    
    init_size = size(volmov);
    min_max1 = [ min(pts_struct.extreme.b, [], 1)', max(pts_struct.extreme.b, [], 1)'];
    min_max2 = [ min(pts_struct.extreme.e, [], 1)', max(pts_struct.extreme.e, [], 1)'];
    min_max = [ min(min_max1(:, 1), min_max2(:, 1)), max(min_max1(:, 2), min_max2(:, 2))];
    d = [10, 10, 5];
    crop_v = [ max(1, min_max(1,1) - d(1)), min(size(volmov, 1), min_max(1,2) + d(1)); ... 
               max(1, min_max(2,1) - d(2)), min(size(volmov, 2), min_max(2,2) + d(2)); ... 
               max(1, min_max(3,1) - d(3)), min(size(volmov, 3), min_max(3,2) + d(3));];
    
    spc_orig = spc;
    for i = 1 : 6
        [tmp, spc] = read_DIR_volume_4dCT(idx, i-1, basepth);
        tmp = crop_data(tmp, crop_v);
        bszv = size(tmp);
        spc_tmp = [1, 1, 1];
        tmpu = volresize(tmp, round(bszv .* spc .* spc_tmp), 1);
        spc = [1,1,1] ./ spc_tmp;
        
%         tmpu = tmp;
        if i == 1
            vols = zeros([size(tmpu), 6]);
        end
        vols(:,:,:, i) = tmpu;
    end
    pts_fix = pts_struct.extreme.b;
    vols = img_thr(vols, 50, 1100, 1);
    opts.pix_resolution = spc;
    opts.border_mask = 5;
    display('run')
    
    vols = reshape(vols, [size(vols,1),size(vols,2),size(vols,3), 1, size(vols, 4)]);
    tic
    [voldef, Tmin3_out, Kmin, itinfo] = ptv_register(vols, [], opts);
    toc
end

%
id1 = 1;
id2 = 6;
[Tnew, imgs_1] = remap_displacements( Tmin3_out, id1, vols, opts.pix_resolution);

Tptv_rsz = cat(4, volresize(Tnew(:,:,:,1,end), bszv), volresize(Tnew(:,:,:,2,end), bszv), volresize(Tnew(:,:,:,3,end), bszv));   
voldef_rsz = volresize(voldef(:,:,:, 1), bszv);

[~, Tr] = uncrop_data(voldef_rsz(:,:,:,1), Tptv_rsz(:,:,:,:), crop_v, init_size);
[pt_errs_phys, pts_moved_pix, TRE_phys, TREstd_phys] = DIR_movepoints(pts_mov, pts_fix, Tr, spc_orig, [0,0,0]);
TRE(idx) = TRE_phys;
TREstd(idx) = TREstd_phys;
fprintf('$$$$$$$$ For idx=%d error = %.3f  std = %.3f,  time=%.1f\n', idx, TRE(idx), TREstd(idx), TIME(idx)); 
    

%%
imgs_exp = [];
Tpix = conv_3d_T_from_phys_to_pix(Tmin3_out(:,:,:,:, :), opts.pix_resolution);
for i = 1 : size(Tpix, 5)
    hold off;
    imagesc(squeeze(vols(:, round(end/2), :, :, i))'); 
    colormap gray;
    daspect([1,1,1]);
    hold on;
    plot_wiremesh(permute(squeeze(Tpix(:, round(end/2), :, [3,2], i)), [2,1,3]), 6, 'r-')
    
    F = getframe;
    imgs_exp = cat(4, imgs_exp, double(F.cdata));
    
    pause(0.1);
end
%%
implay_2d_deform( permute(squeeze(vols(:, round(end/2), :, :, :)), [2, 1, 3]),  permute(squeeze(imgs_1(:, round(end/2), :, :, :)), [2, 1, 3]), ...
    permute(squeeze(Tpix(:, round(end/2), :, :, :)), [2, 1, 3, 4]), 5, false, [0,1]);
%%
ima = permute(squeeze(voldef(:, round(end/2), :, :, :)), [2,1,3]);
savegif('results/DIR_group_track.gif', squeeze([imgs_exp]/250), 1/5);
savegif('results/DIR_group_stab.gif', ima, 1/5);
    
    
    
