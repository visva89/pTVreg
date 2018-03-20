function Y = reshape_3d_to_4d(X, sz_orig)
    Y = reshape(X, [size(X,1),size(X,2),sz_orig(3), sz_orig(4)]);
end