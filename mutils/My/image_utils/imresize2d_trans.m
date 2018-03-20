function A = imresize2d_trans(V,scale,tsize,ntype,npad)
    A1 = imresize(V(:,:,1), tsize);
    A2 = imresize(V(:,:,2), tsize);
    A = cat(3, A1, A2);
end