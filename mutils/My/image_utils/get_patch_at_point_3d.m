function patch = get_patch_at_point_3d(vol, center, hwidth)
    %%TODO: pad with zeros
    patch = zeros(hwidth * 2 + 1);
    L = ones(1, 3);
    R = size(vol);
    
    L = max(L, center - hwidth);
    R = min(R, center + hwidth);
    patch = vol(L(1):R(1), L(2):R(2), L(3):R(3));    
end