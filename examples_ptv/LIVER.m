addpath(genpath('../mutils/My/'));
addpath(genpath('../ptv'));
load('data/ETH_Liver.mat');

%% 
pmoved_i = cell(4, 2);
pmoved_o = cell(4, 2);
TREs_i = cell(4, 2);
TREs_o = cell(4, 2);
[nidx, nidxx] = ndgrid(1:size(d_idxs, 1), 1:2);
trei = [];
treo = [];

% configure registration
opts = [];
opts.metric = 'loc_cc_fftn_gpu';
opts.grid_spacing = [4,4,3];
opts.display = 'off';
opts.max_iters = 80; 
opts.metric_param = 2.5 * [1,1,1]; 
opts.interp_type = 1;
opts.spline_order = 1;
opts.isoTV = 0.11;
opts.loc_cc_approximate = false;
opts.border_mask = 1;
opts.k_down = 0.7;
opts.check_gradients = 100*0;

TIMES = [];
mTREi = [];
mTREo = [];
for pi =  1:numel(nidx)
    idx = nidx(pi);
    idxx = nidxx(pi);
    spc = infos{idx,3}.PixelDimensions;
    fx = vols{idx, 3};
    gx = vols{idx, idxx};
    volfix = vols{idx, 3};
    volmov = vols{idx, idxx};
    opts.pix_resolution = spc;

    timer = tic();
    [voldef_pl, Tmin_pl, Kmin_pl] = ptv_register(gx, fx, opts);
    TIMES(pi) = toc(timer);
    T = Tmin_pl;
    
    pt_mov_o = pts_outside{idx, idxx};
    pt_fix_o = pts_outside{idx, 3};
    pt_mov_i = pts_inside{idx, idxx};
    pt_fix_i = pts_inside{idx, 3};
    
    pt_mov = [pt_mov_i, pt_mov_o];
    pt_fix = [pt_fix_i, pt_fix_o];
    
    [pts_moved, TRE] = ETHliver_cmp_pts(T, pt_fix, pt_mov, spc);
    
    [pts_moved_i, TRE_i] = ETHliver_cmp_pts(T, pt_fix_i, pt_mov_i, spc);
    [pts_moved_o, TRE_o] = ETHliver_cmp_pts(T, pt_fix_o, pt_mov_o, spc);
    
    pmoved_i{pi} = pts_moved_i;
    pmoved_o{pi} = pts_moved_o;
    TREs_i{pi} = TRE_i;
    TREs_o{pi} = TRE_o;
    
    [mean(TREs_i{idx, idxx}), mean(TREs_o{idx, idxx})]
    mTREi(pi) = mean(TREs_i{idx, idxx});
    mTREo(pi) = mean(TREs_o{idx, idxx});
    
    trei = [trei; TREs_i{idx, idxx}(:)];
    treo = [treo; TREs_o{idx, idxx}(:)];
end
[mean(trei), mean(treo)]
[mean(mTREi), mean(mTREo)]
save('results/LIVER_TRE.mat', 'mTREi', 'mTREo', 'TIMES');
