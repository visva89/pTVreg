function A = imresize3d_trans(V,scale,tsize,ntype,npad)
    A1 = imresize3d(V(:,:,:,1), scale, tsize, ntype, npad);
    A2 = imresize3d(V(:,:,:,2), scale, tsize, ntype, npad);
    A3 = imresize3d(V(:,:,:,3), scale, tsize, ntype, npad);
    A = cat(4, A1, A2, A3);
end