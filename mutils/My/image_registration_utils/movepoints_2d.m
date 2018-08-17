function pts_m = movepoints_2d(D, pts, type)
    [n1,n2] = ndgrid(1:size(D,1), 1:size(D,2));
    v1 = griddata(n1, n2, D(:,:,1) + n1, pts(1, :), pts(2, :), type);
    v2 = griddata(n1, n2, D(:,:,2) + n2, pts(1, :), pts(2, :), type);
    pts_m = cat(1, v1(:)', v2(:)');
end