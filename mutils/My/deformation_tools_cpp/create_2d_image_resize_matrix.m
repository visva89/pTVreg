function R = create_2d_image_resize_matrix(insz, outsz)
    t1 = (insz(1) - outsz(1)) * repmat(linspace(0, 1, outsz(1))', [1, outsz(2)]);
    t2 = (insz(2) - outsz(2)) * repmat(linspace(0, 1, outsz(2)), [outsz(1), 1]);
%     R = create_2d_bicubic_interp_matrix(cat(3, t1, t2), insz);
%      R = create_2d_bicubic_interp_matrix(cat(3, t1, t2), insz);
     R = create_2d_bilinear_interp_matrix(cat(3, t1, t2), insz);
end