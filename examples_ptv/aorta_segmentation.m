addpath(genpath('../mutils/My/'));
addpath(genpath('../ptv'));
%%
dat = load('data/aortha_segmentation.mat');
volmov = double(dat.volmov);
volfix = double(dat.volfix);
maskmov = double(dat.maskmov);
maskfix = double(dat.maskfix);
%%
opts = [];

opts.grid_spacing = [6,6,6];
opts.display = 'off';
opts.max_iters = 70; 

opts.metric = 'sad';
opts.isoTV=0.02*0; 
opts.D2L1 = 0.07;
opts.folding_penalty = 1e-1;

opts.nlvl = 7;
opts.pix_resolution = [1,1,1];
opts.interp_type = 0;
opts.k_down = 0.75;
opts.spline_order = 1;

opts.mov_segm = maskmov;
opts.segm_val0 = 0.2;
opts.segm_val1 = 0.95;
opts.segm_koef = 0.05;

[voldef_pl, Tmin_pl, Kmin_pl] = ptv_register(volmov, volfix, opts);
%%
maskdef = imdeform3(double(maskmov), Tmin_pl, 0);
d1 = dice_coef(maskmov, maskfix);
d2 = dice_coef(maskdef, maskfix);
fprintf('Initial DICE=%.2f, \nRegistered DICE=%.2f\n', d1, d2);

%%
maskdef = imdeform3(double(maskmov), Tmin_pl, 0);
maskdef_BW = imclose(maskdef>0.5, strel('sphere',5));
for d = -8:9
slc = round(size(volfix,3)/2)+d;
slc2 = round(size(volfix,2)/2)+d;
subplot(331);
imagesc(volfix(:,:, slc)); colormap gray;
xticks([]); yticks([]);
title('Fixed image', 'interpreter', 'latex');

subplot(332);
imagesc(voldef_pl(:,:, slc)); colormap gray;
xticks([]); yticks([]);
title('Deformed image', 'interpreter', 'latex');


subplot(333);
hold off;
imagesc(volmov(:,:, slc)); colormap gray;
hold on;
plot_wiremesh(squeeze(Tmin_pl(:, :, slc, [1,2])), 4, 'r-');
xticks([]); yticks([]);
title('Moving image', 'interpreter', 'latex');


subplot(334);
imagesc(squeeze(volfix(:,slc2, :))); colormap gray;
xticks([]); yticks([]);
title('Fixed image', 'interpreter', 'latex');

subplot(335);
imagesc(squeeze(voldef_pl(:,slc2, :))); colormap gray;
xticks([]); yticks([]);
title('Deformed image', 'interpreter', 'latex');


subplot(336);
hold off;
imagesc(squeeze(volmov(:,slc2, :))); colormap gray;
hold on;
plot_wiremesh(squeeze(Tmin_pl(:, slc2, :, [1,3])), 4, 'r-');
xticks([]); yticks([]);
title('Moving image', 'interpreter', 'latex');

subplot(337);  
hold off;
imagesc(squeeze(volfix(:,:,slc))); colormap gray;
hold on;
B = bwboundaries(maskfix(:,:, slc));
plot(B{1}(:, 2), B{1}(:, 1), 'r--');
B = bwboundaries(maskdef_BW(:,:, slc));
for i = 1 : numel(B)
    plot(B{i}(:, 2), B{i}(:, 1), 'b-');
end
xticks([]); yticks([]);
title('Fixed img. w. segm. overlay', 'interpreter', 'latex');

subplot(338);
hold off;
imagesc(squeeze(volfix(:,slc2,:))); colormap gray;
hold on;
B = bwboundaries(squeeze(maskfix(:,slc2,:)));
leg1=plot(B{1}(:, 2), B{1}(:, 1), 'r--');
B = bwboundaries(squeeze(maskdef_BW(:,slc2,:)));
for i = 1 : numel(B)
    leg2=plot(B{i}(:, 2), B{i}(:, 1), 'b-');
end
xticks([]); yticks([]);
title('Fixed img. w. segm. overlay', 'interpreter', 'latex');

legend([leg1, leg2], {'Registered segmentation', 'Manual segmentation'}, 'Location', 'bestoutside');
pause;
end