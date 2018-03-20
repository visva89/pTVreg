addpath(genpath('../mutils/My/'));
addpath(genpath('../ptv'));
%%
load('data/rolling_shutter2.mat');
imgs = double(imgs)/255;

opts = [];
opts.mean_penalty = 1e-4*1;
opts.pix_resolution = [1,1];
opts.grid_spacing = [10, 10];
opts.spline_order = 1;
opts.display = 'off';
opts.border_mask = 10;
opts.k_down = 0.8;
opts.max_iters = 80;
opts.isoTV = 1e-3;
opts.metric = 'nuclear';

tic
[voldef_nuclear, Tmin_nuclear] = ptv_register(imgs, [], opts);
toc
%% pairwise registration
opts.isoTV = 1e-4;
opts.mean_penalty = 0;
opts.metric = 'ssd';
[voldef_ssd] = ptv_register(imgs, imgs(:,:,:,:, 1), opts);
%%
imgs_a = imgs * 0;
imgs_r = imgs * 0;
imgs_s = imgs * 0;
mask = ones(size(imgs_a, 1), size(imgs_a, 2));
mask(1:30, :) = 0; mask(end-30:end, :) = 0;
mask(:, 1:30) = 0; mask(:, end-30:end) = 0;
for i = 1 : size(imgs, 5)
    [t1, t2, alpha, TransMat, Dr] = estimate_rigid_from_displ(squeeze(Tmin_nuclear(:,:,1, :, i)), mask);
    [t1, t2, alpha, TransMat, scale, Ds] = estimate_rigid_scale_from_displ(squeeze(Tmin_nuclear(:,:,1, :, i)), mask);
    [~, Da] = estimate_affine_from_displ(squeeze(Tmin_nuclear(:,:,1, :, i)), mask);
    imgs_a(:,:, 1, :, i) = imdeform2(squeeze(imgs(:,:, 1, :, i)), Da);
    imgs_r(:,:, 1, :, i) = imdeform2(squeeze(imgs(:,:, 1, :, i)), Dr);
    imgs_s(:,:, 1, :, i) = imdeform2(squeeze(imgs(:,:, 1, :, i)), Ds);
end
%%
implay(squeeze([imgs, voldef_nuclear, voldef_ssd; imgs_r, imgs_s, imgs_a])*2)
%%
savegif('results/rolling_shutter_register.gif', squeeze([imgs, voldef_nuclear])*2, 1/20);
savegif('results/rolling_shutter_rig_affing.gif', squeeze([imgs_s, imgs_a])*2, 1/20);
%% particle track image
imgs_k = imgs;
dd = 10;
[g1, g2] = ndgrid(1:dd:size(imgs, 1), 1:dd:size(imgs, 2));
gidxs = g1 + (g2-1)*size(imgs, 1);
for i = 1 : size(imgs, 5)
    T1 = Tmin_nuclear(:,:, 1, 1, i);
    T2 = Tmin_nuclear(:,:, 1, 2, i);
    gg1 = round(g1(:) + T1(gidxs(:)));
    gg2 = round(g2(:) + T2(gidxs(:)));
    gg1 = max(gg1, 1);
    gg1 = min(gg1, size(imgs, 1));
    gg2 = max(gg2, 1);
    gg2 = min(gg2, size(imgs, 2));
    ggidxs = gg1 + (gg2-1) * size(imgs, 1);
    
    timg = squeeze(imgs_k(:,:, 1, :, i));
    
    timg(ggidxs) = 1;
    imgs_k(:,:, 1, :, i) = timg;
end