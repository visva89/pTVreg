function val = lerp_eval(pt_pix, vol)
		ax_l = floor(pt_pix(1));
        ay_l = floor(pt_pix(2));
        az_l = floor(pt_pix(3));
		ax_h = ceil(pt_pix(1));
        ay_h = ceil(pt_pix(2));
        az_h = ceil(pt_pix(3));
		ax_l = max(1, ax_l);
		ay_l = max(1, ay_l);
		az_l = max(1, az_l);
		ax_h = min(size(vol, 1), ax_h);
		ay_h = min(size(vol, 2), ay_h);
		az_h = min(size(vol, 3), az_h);
		ax = pt_pix(1) - ax_l;
		ay = pt_pix(2) - ay_l;
		az = pt_pix(3) - az_l;
		
		val = lerp(vol([ax_l,ax_h],[ay_l,ay_h],[az_l,az_h]), ax, ay, az);
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
