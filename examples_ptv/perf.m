addpath(genpath('../mutils/My/'));
addpath(genpath('../ptv'));
%%
dat = load('data/perf.mat');
imgs = abs(dat.Rawdata);
imgs = sqrt(double(reshape(imgs, [size(imgs, 1), size(imgs, 2), 1, 1, size(imgs,3)])));
%sqrt is a dirty trick to get rid of highlights
imgs = imgs ./ max(max(imgs, [], 1), [], 2);

opts = [];
opts.pix_resolution = [1,1];
opts.metric = 'nuclear';

opts.grid_spacing = [4, 4];
opts.isoTV = 6e-2;
opts.isoTV = 3e-2;
opts.jac_reg = 2;

opts.spline_order = 1;
opts.max_iters = 100;
opts.display = 'off';

opts.border_mask = 6;
opts.k_down = 0.7;
opts.max_iters = 120;


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
    plot_wiremesh(squeeze(Tmin_pl(:,:, 1, :, i)), 8, 'r-');
    daspect([1,1,1]);
    F = getframe;
    imgs_exp = cat(4, imgs_exp, double(F.cdata));
%     pause(0.1);
end
%%
savegif('results/perf_track.gif', squeeze([imgs_exp]/250), 1/15);
savegif('results/perf_register.gif', squeeze([imgs, voldef_pl]), 1/15);