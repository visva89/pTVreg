function pts_new = move_points_lerp_phys(pts, T, pix_spacing, corner_coord)
    pts_new = pts;
    if isempty(pix_spacing)
        spc = ones(3,1);
    else
        spc = pix_spacing;
    end
    
    if isempty(corner_coord)
        iden = zeros(3,1);
    else
        iden = corner_coord;
    end
    
    for i = 1 : size(pts, 1)
        pt = fl(pts(i, :)) + iden;
		ax_l = floor(pt(1) / spc(1));
        ay_l = floor(pt(2) / spc(2));
        az_l = floor(pt(3) / spc(3));
		ax_h = ceil(pt(1) / spc(1));
        ay_h = ceil(pt(2) / spc(2));
        az_h = ceil(pt(3) / spc(3));
		ax_l = max(1, ax_l);
		ay_l = max(1, ay_l);
		az_l = max(1, az_l);
		ax_h = min(size(T, 1), ax_h);
		ay_h = min(size(T, 2), ay_h);
		az_h = min(size(T, 3), az_h);
		ax = pt(1)/spc(1) - ax_l;
		ay = pt(2)/spc(2) - ay_l;
		az = pt(3)/spc(3) - az_l;
		
		dx = lerp(T([ax_l,ax_h],[ay_l,ay_h],[az_l,az_h], 1), ax, ay, az);
		dy = lerp(T([ax_l,ax_h],[ay_l,ay_h],[az_l,az_h], 2), ax, ay, az);
		dz = lerp(T([ax_l,ax_h],[ay_l,ay_h],[az_l,az_h], 3), ax, ay, az);

        pts_new(i, 1) = pts(i, 1) + dx;
        pts_new(i, 2) = pts(i, 2) + dy;
        pts_new(i, 3) = pts(i, 3) + dz;
    end
end

function f = lerp(V, tx, ty, tz)
	c00 = V(1,1,1) * (1-tx) + V(2,1,1) * tx;
	c10 = V(1,2,1) * (1-tx) + V(2,2,1) * tx;
	c01 = V(1,1,2) * (1-tx) + V(2,1,2) * tx;
	c11 = V(1,2,2) * (1-tx) + V(2,2,2) * tx;

	c0 = c00 * (1-ty) + c10 * ty;
	c1 = c01 * (1-ty) + c11 * ty;
	
	f = c0 * (1 - tz) + c1 * tz;
end
