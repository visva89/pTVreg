addpath(genpath('../mutils/My/'));
addpath(genpath('../ptv'));
%%
load('data/face_align.mat');

imgs = double(imgs) / 255;
imgs = imgs ./ max(max(max(imgs,[],1), [], 2), [], 3);

opts = [];
opts.pix_resolution = [1,1];
opts.metric = 'nuclear';


opts.grid_spacing = [10, 10];
opts.isoTV = 0.07;
opts.k_down = 0.8;


opts.mean_penalty = 1e-2; 
opts.spline_order = 1;
opts.max_iters = 100;
opts.border_mask = 15;

tic
[voldef_pl, Tmin_pl,  ~] = ptv_register(imgs, [], opts);
toc
%% pairwise lcc registration super slow and worse
opts.metric = 'loc_cc_fftn';
opts.isoTV = 0.1;
opts.mean_penalty = 0;
opts.loc_cc_approximate = true;
opts.metric_param = [3, 3];
[voldef_pw, Tmin_pw,  ~] = ptv_register(imgs, imgs(:,:,:, :, 1), opts);

%% extract linear transformations
imgs_a = imgs * 0;
imgs_r = imgs * 0;
imgs_s = imgs * 0;
imgs_d = imgs * 0;
mask = ones(size(imgs_a, 1), size(imgs_a, 2));
mask(1:25, :) = 0; mask(end-25:end, :) = 0;
mask(:, 1:40) = 0; mask(:, end-20:end) = 0;
for i = 1 : size(imgs, 5)
    [t1, t2, alpha, TransMat, Dr] = estimate_rigid_from_displ(squeeze(Tmin_pl(:,:,1, :, i)), mask);
    [t1, t2, alpha, TransMat, scale, Ds] = estimate_rigid_scale_from_displ(squeeze(Tmin_pl(:,:,1, :, i)), mask);
    [~, Da] = estimate_affine_from_displ(squeeze(Tmin_pl(:,:,1, :, i)), mask);
    imgs_a(:,:, 1, :, i) = imdeform2(squeeze(imgs(:,:, 1, :, i)), Da, 1);
    imgs_r(:,:, 1, :, i) = imdeform2(squeeze(imgs(:,:, 1, :, i)), Dr, 1);
    imgs_s(:,:, 1, :, i) = imdeform2(squeeze(imgs(:,:, 1, :, i)), Ds, 1);
    imgs_d(:,:, 1, :, i) = imdeform2(squeeze(imgs(:,:, 1, :, i)), squeeze(Tmin_pl(:,:, 1, :, i)), 1);
end
%%
% implay(squeeze([imgs, imgs_d, imgs_r, imgs_s, imgs_a]));

%% particle track image
imgs_k = imgs*0.9;
dd = 6;
[g1, g2] = ndgrid(1:dd:size(imgs, 1), 1:dd:size(imgs, 2));
gidxs = g1 + (g2-1)*size(imgs, 1);
for i = 1 : size(imgs, 5)
    T1 = Tmin_pl(:,:, 1, 1, i);
    T2 = Tmin_pl(:,:, 1, 2, i);
    gg1 = round(g1(:) + T1(gidxs(:)));
    gg2 = round(g2(:) + T2(gidxs(:)));
    gg1 = max(gg1, 1);
    gg1 = min(gg1, size(imgs, 1));
    gg2 = max(gg2, 1);
    gg2 = min(gg2, size(imgs, 2));
    ggidxs = gg1 + (gg2-1) * size(imgs, 1);
    
    timg = squeeze(imgs_k(:,:, 1, :, i));
    
    timg(ggidxs) = 1;
    npix = size(imgs_k,1)*size(imgs_k,2);
    timg(ggidxs+npix) = 0;
    timg(ggidxs+2*npix) = 0;
    timg(max(min(ggidxs+1, numel(timg)), 1)) = 1;
    timg(max(min(ggidxs+1+ npix, numel(timg)), 1)) = 0;
    timg(max(min(ggidxs+1+ 2*npix, numel(timg)), 1)) = 0;
    
    imgs_k(:,:, 1, :, i) = timg;
    
    
end
%%
savegif('results/faces_register.gif', squeeze([imgs, imgs_d]), 1/20);
savegif('results/faces_register_rigids_affine.gif', squeeze([imgs_s, imgs_a]), 1/20);
savegif('results/faces_track.gif', imresize(squeeze(imgs_k), 1), 1/20);
