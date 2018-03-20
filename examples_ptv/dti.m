addpath(genpath('../mutils/My/'));
addpath(genpath('../ptv'));
%%
dat = load('data/dti.mat');
imgs = double(reshape(dat.imgs, [size(dat.imgs, 1), size(dat.imgs, 2), 1, 1, size(dat.imgs,3)]));


opts = [];
opts.check_gradients = 155*0;
opts.pix_resolution = [1,1];
opts.metric = 'nuclear';


opts.grid_spacing = [10, 10];
opts.isoTV = 5e-2;
opts.mean_penalty = 1e-3;

opts.spline_order = 1;
opts.max_iters = 100;
opts.display = 'off';

opts.border_mask = 6;
opts.k_down = 0.7;

tic
[voldef_pl, Tmin_pl,  Kmin_pl] = ptv_register(imgs, [], opts);
toc

%%
savegif('results/dti_register.gif', squeeze([imgs, voldef_pl])*1, 1/20);
%%
dat = load('data/dti2.mat');
imgs = double(abs( reshape(dat.data_to_save(:,:, 2, :, :), 55,116, [])));
imgs = double(reshape(imgs, [size(imgs, 1), size(imgs, 2), 1, 1, size(imgs,3)]));

imgs = imgs ./ max(max(imgs, [], 1), [], 2);

opts = [];
opts.check_gradients = 155*0;
opts.pix_resolution = [1,1];
opts.metric = 'nuclear';


opts.grid_spacing = [6, 6];
opts.isoTV = 5e-3;
opts.mean_penalty = 1e-5*0;

opts.spline_order = 1;
opts.max_iters = 100;
opts.display = 'off';

opts.border_mask = 6;
opts.k_down = 0.7;

tic
[voldef_pl, Tmin_pl,  Kmin_pl] = ptv_register(imgs, [], opts);
toc

%%
savegif('results/dti_register2.gif', squeeze([imgs, voldef_pl])*2, 1/20);