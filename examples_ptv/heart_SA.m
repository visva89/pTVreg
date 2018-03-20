addpath(genpath('../mutils/My/'));
addpath(genpath('../ptv'));
%%
data = load('data/SA_ppu.mat');
%%
imgs2 = abs(double(squeeze(data.data)));
imgs = imgs2(60:140,80:170, 40:end);
imgs = reshape(imgs, [size(imgs, 1), size(imgs,2), 1,1, size(imgs, 3)]);
imgs(imgs> 1000) = 1000;

opts = [];
opts.pix_resolution = [1, 1];
opts.interp_type = 0;

maxpf= max(max(imgs, [], 1), [],  2);
imgs = bsxfun(@rdivide, imgs, maxpf);


opts.border_mask = 5;


opts.singular_coefs = ones(1, size(imgs, 5));
opts.singular_coefs(1) = 0;


opts.T_D2L1 = 1e-2;
opts.D2L1 = 1e-2;
opts.isoTV = 0.000;


opts.max_iters = 150;
opts.grid_spacing = [4, 4];
opts.cp_refinements = 0;

opts.display = 'iter';
opts.metric = 'nuclear';
opts.k_down = 0.75;
opts.check_gradients = 0; 
opts.spline_order = 3;
opts.display = 'off';


tic
[voldef, Tmin_out] = ptv_register(imgs, [], opts);
toc
szs = size(imgs);
%% we can mad displacements back to the first reference frame
refid = 1;
[T_1, imgs_1] = remap_displacements(Tmin_out, refid, imgs, opts.pix_resolution);

%%
imgs_exp = [];
for i = 1 : size(imgs, 5)
    hold off;
    imagesc(squeeze(imgs(:,:, 1, :, i)));
    colormap gray;
    hold on;
    plot_wiremesh(squeeze(T_1(:,:, 1, :, i)), 4, 'r-');
    daspect([1,1,1]);
    F = getframe;
    imgs_exp = cat(4, imgs_exp, double(F.cdata));
%     pause(0.1);
end
%%
savegif('results/heart_SA_register.gif', squeeze([imgs, voldef]), 1/20);
savegif('results/heart_SA_track.gif', squeeze([imgs_exp]/250), 1/20);