function pts_new = move_points_phys(pts, T, pix_spacing, ident)
    pts_new = pts;
    if isempty(pix_spacing)
        pix_spacing = ones(3,1);
    end
    
    for i = 1 : size(pts, 1)
        ax = round(ident(1) + pts(i, 1) / pix_spacing(1));
        ay = round(ident(2) + pts(i, 2) / pix_spacing(2));
        az = round(ident(3) + pts(i, 3) / pix_spacing(3));
        
        pts_new(i, 1) = pts(i, 1) + T(ax, ay, az, 1);
        pts_new(i, 2) = pts(i, 2) + T(ax, ay, az, 2);
        pts_new(i, 3) = pts(i, 3) + T(ax, ay, az, 3);
    end
end

