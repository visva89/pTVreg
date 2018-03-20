function pts_new = simple_move_points_lerp(pts, T, ident)
    pts_new = pts;
    pd = ones(3,1);
    for i = 1 : size(pts, 1)
		ax_l = floor(ident(1) + pts(i, 1) / pd(1));
        ay_l = floor(ident(2) + pts(i, 2) / pd(2));
        az_l = floor(ident(3) + pts(i, 3) / pd(3));
		ax_h = ceil(ident(1) + pts(i, 1) / pd(1));
        ay_h = ceil(ident(2) + pts(i, 2) / pd(2));
        az_h = ceil(ident(3) + pts(i, 3) / pd(3));
		ax_l = max(1, ax_l);
		ay_l = max(1, ay_l);
		az_l = max(1, az_l);
		ax_h = min(size(T, 1), ax_h);
		ay_h = min(size(T, 2), ay_h);
		az_h = min(size(T, 3), az_h);
		ax = ident(1) + pts(i,1) - ax_l;
		ay = ident(2) + pts(i,2) - ay_l;
		az = ident(3) + pts(i,3) - az_l;
		
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
