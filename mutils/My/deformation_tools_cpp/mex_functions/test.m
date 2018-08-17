addpath('bin');
% volsz = [512, 512, 255];
volsz = [100, 100, 100];
% volsz = [250, 250, 200];
spacing = [8, 8, 8];
spacing = [4, 4, 4];
k = ceil(volsz ./ spacing) + 1;
Knots = (rand([k, 3]) - 0.5) * 20;
sKnots = single(Knots);
dKnots = double(Knots);
gsKnots = gpuArray(sKnots);
gdKnots = gpuArray(dKnots);
vol = single(rand(volsz))*0;
vol(20:end-20, 20:end-20, 20:end-20) = 1;
dvol = double(vol);
gvol = gpuArray(vol);
gdvol = gpuArray(dvol);
%%
tic
disp = mex_3d_linear_disp_float(sKnots, single(volsz), single(spacing));
toc

tic
dispg = mex_3d_linear_disp_GPU_float(gsKnots, single(volsz), single(spacing));
toc

% dispg = gather(dispg);
sum(abs(disp(:) - gather(dispg(:))))
max(abs(disp(:) - gather(dispg(:))))
%%

tic
vdef = mex_3d_volume_warp_float(vol, disp, single(0));
toc

tic
vdefg = mex_3d_volume_warp_GPU_float(gvol, dispg, single(0));
toc
max(abs(vdef(:) - vdefg(:)))

%%
display('---');
tic
for i = 1 : 10
disp = mex_3d_linear_disp_float(sKnots, single(volsz), single(spacing));
vdef = mex_3d_volume_warp_float(vol, disp, single(0));
end
toc
%%
display('...');
tic
for i = 1 : 10
dispg = mex_3d_linear_disp_GPU_float(gsKnots, single(volsz), single(spacing));
vdefg = mex_3d_volume_warp_GPU_float(gvol, dispg, single(0));
end
toc

%%
volsz = [200, 255, 257];
spacing = [3, 3, 3];
ksz = ceil(volsz ./ spacing) + 1;

G1 = rand(volsz);
G2 = rand(volsz) * 0;
G2(30:end-30, 30:end-30, 30:end-30) = 1;
G3 = rand(volsz);

G1 = single(G1);
G2 = single(G2);
G3 = single(G3);

gG1 = gpuArray(G1);
gG2 = gpuArray(G2);
gG3 = gpuArray(G3);

tic
[gr1, gr2, gr3] = mex_3d_linear_partial_conv_float(G1, G2, G3, single(ksz), single(spacing));
toc

tic
[ggr1, ggr2, ggr3] = mex_3d_linear_partial_conv_GPU_float(gG1, gG2, gG3, single(ksz), single(spacing));
toc

[max(abs(gr1(:) - ggr1(:))), max(abs(gr2(:) - ggr2(:))), max(abs(gr3(:) - ggr3(:)))]

%%
addpath('..');
% addpath('mex_functions/bin');

tic
for i = 1 : 30
    voldef = linear_disp_and_warp_3d((sKnots), (vol), spacing, 0, 0, 0);
end
toc
%%
tic
for i = 1 :30
voldefg = linear_disp_and_warp_3d((gdKnots), (gdvol), spacing, 0, 0, 0);
end
toc
%%
display('----')
tic
D = mex_3d_linear_disp_GPU_float(gsKnots, single(size(gvol)), single(spacing));
toc
tic
voldef1 = mex_3d_volume_warp_GPU_float(gvol, D, single(0));
toc
% tic
% voldef2 = mex_3d_volume_warp_GPU_float(gvol, D, single(0));
% toc
% tic
% voldef3 = mex_3d_volume_warp_GPU_float(gvol, D, single(0));
% toc

%%
addpath('bin');
mex  -output bin/mex_3d_cubic_disp_double CXX='g++' CXXFLAGS='\$CXXFLAGS -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_3d_cubic_disp.cpp ../cubic_grid.cpp
vols = [270,270,270];
spc = [8,8,8];
k = ceil(vols ./ spc) + 3;
Knots = rand([k, 3]);
Knots = Knots * 0;
Knots(2, 2, 2,1) = 5;
Knots(5, 5, 2,1) = 10;
% Knots(2, 3, 1,1) = -5;
tic
D = mex_3d_cubic_disp_double(Knots, vols, spc);
toc
subplot(121)
imagesc(D(:,:,1,1)); colorbar
subplot(122)
imagesc(D(:,:,2,1)); colorbar
%%
spc = 4;
b = -ones(spc*4, 1);
for i = 1 : 2*spc + 1
    t = (i-1)/spc;
    if i <= spc
        k = t;
        f = 3*k^3 - 5 * k * k + 2;
    else
        k = t - 1;
        f = -k^3 + 2*k^2 - k;
    end
    b(2*spc+i-1) = f/2;
    if i <= 2*spc
        b(2*spc - i+1) = f/2;
    end
end
plot(b(1:end-1), 'r.-');
size(b)
%%
% mex  -output bin/mex_3d_cubic_partial_conv_double CXX='g++' CXXFLAGS='\$CXXFLAGS -O3 -funroll-loops -fopenmp -I../../mex_helpers -I../../deformation_tools_cpp' LDFLAGS="\$LDFLAGS -fopenmp" mex_3d_cubic_partial_conv.cpp ../cubic_grid.cpp
tr = rand(270, 270, 270);
spc = [2,2,2];
spc = [8,8,8];
ksz = ceil(size(tr)./spc) + 3;
tic
[g1, g2, g3] = mex_3d_cubic_partial_conv_double(tr, tr, tr, ksz, spc);
toc
ksz2 = ceil(size(tr)./spc) + 1;
tic
% [gg1, gg2, gg3] = mex_3d_linear_partial_conv_double(tr, tr, tr, ksz2, spc);
toc

%% upsmpl test
vol = zeros(100, 100, 100);
spc = [8,8,8];
k1 = ceil( (size(vol)-1) ./ spc) + 3;
k2 = ceil( (2*size(vol)-1) ./ spc) + 3;
Knots1 = rand([k1, 3]);
Knots1(4:round(end), 4:round(end/2), :, 1) = 13;
Knots2 = refine_cubic_grid_3d(Knots1, spc, spc, [1,1,1], size(vol)*2, size(vol));
%
D1 = mex_3d_cubic_disp_double(Knots1, size(vol), spc);
D2 = mex_3d_cubic_disp_double(Knots2, 2*size(vol), spc);
subplot(221)
imagesc(D1(:,:, 1, 1));
subplot(222)
imagesc(D2(:,:, 1, 1));

subplot(223)
imagesc(Knots1(:,:, round(end/2), 1));
subplot(224)
imagesc(Knots2(:,:, round(end/2), 1));
%%

subplot(121);
hold off;
ti1 = 0:(size(vol, 1)-1);
ti2 = (0:(2*size(vol, 1)-1))/2;
plot(ti1, squeeze(D1(round(end/3),:, 1,1)), 'bo-')
hold on;
plot(ti2, squeeze(D2(round(end/3),:, 1,1)), 'r.-')
subplot(121);
t1 = interp1(ti1, squeeze(D1(33,:, 1,1)), ti2);
plot(ti2, t1 - squeeze(D2(round(end/3),:,1,1)), 'k');
grid on;
subplot(122);
hold off
plot( (0:(k1(1)-1))-spc(1), squeeze(Knots1(15, :, 1,1)), 'bx-');
hold on;
plot((0:k2(1)-1)/2 - spc(1)*7/8, squeeze(Knots2(15, :, 1,1)), 'ro-');
%%
hold off;
plot(1:size(vol, 1), D1(:, 1, 1, 1), 'r.-');
hold on;
Ktmp =Knots1(2:end-1, 2, 2, 1); 
plot(1 + (0:size(Ktmp,1)-1)*spc(1), Ktmp, 'bo-');

Ktmp =Knots2(2:end-1, 2, 2, 1); 
plot(1 + (0:size(Ktmp,1)-1)*spc(1)/2, Ktmp, 'ks-');
