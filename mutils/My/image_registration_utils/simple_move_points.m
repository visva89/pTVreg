function pts_new = simple_move_points(pts, T, ident)
    pts_new = pts;
    pd = ones(3,1);
    for i = 1 : size(pts, 1)
        ax = round(ident(1) + pts(i, 1) / pd(1));
        ay = round(ident(2) + pts(i, 2) / pd(2));
        az = round(ident(3) + pts(i, 3) / pd(3));
        
        pts_new(i, 1) = pts(i, 1) + pd(1) * T(ax, ay, az, 1);
        pts_new(i, 2) = pts(i, 2) + pd(2) * T(ax, ay, az, 2);
        pts_new(i, 3) = pts(i, 3) + pd(3) * T(ax, ay, az, 3);
    end
end

