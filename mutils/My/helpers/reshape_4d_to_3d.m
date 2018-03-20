function Y = reshape_4d_to_3d(X)
    Y = reshape(X, [size(X,1),size(X,2),size(X,3)*size(X,4)]);
end