addpath(genpath('../mutils/My/'));
addpath(genpath('../ptv'));
%%
dat = load('data/molli.mat');
imgs = double(reshape(dat.imgs, [size(dat.imgs, 1), size(dat.imgs, 2), 1, 1, size(dat.imgs,3)]));
imgs = imgs(50:160, 50:160, :, :, :);

opts = [];
opts.check_gradients = 155*0;
opts.mean_penalty = 1e-3;
opts.pix_resolution = [1,1];
opts.metric = 'nuclear';


opts.grid_spacing = [10, 10];
opts.isoTV = 5e-3;

opts.spline_order = 1;
opts.max_iters = 100;

opts.display = 'off';
opts.opt_method = 'lbfsg';

opts.border_mask = 6;
opts.k_down = 0.7;

tic
[voldef_pl, Tmin_pl,  Kmin_pl] = ptv_register(imgs, [], opts);
toc

%%
imgs_exp = [];
for i = 1 : size(imgs, 5)
    hold off;
    imagesc(squeeze(imgs(:,:, 1, :, i)));
    colormap gray;
    hold on;
    plot_wiremesh(squeeze(Tmin_pl(:,:, 1, :, i)), 10, 'r-');
    daspect([1,1,1]);
    F = getframe;
    imgs_exp = cat(4, imgs_exp, double(F.cdata));
%     pause(0.1);
end
%%
savegif('results/molli_register.gif', squeeze([imgs, voldef_pl]), 1/5);
savegif('results/molli_track.gif', squeeze([imgs_exp]/250), 1/5);