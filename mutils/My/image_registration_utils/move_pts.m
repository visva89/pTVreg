function dpts = move_pts(pts, By, Bx)
dpts = pts;
for j = 1 : size(pts, 2)
    r = ceil(pts(1, j));
    c = ceil(pts(2, j));
    dpts(1, j) = dpts(1, j) + By(r, c);
    dpts(2, j) = dpts(2, j) + Bx(r, c);
end
    