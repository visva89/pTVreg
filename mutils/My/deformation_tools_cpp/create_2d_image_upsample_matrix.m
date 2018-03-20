function A = create_2d_image_upsample_matrix(insz, outsz, varargin)
    % (insz, outsz, {interp_type})
    interp_type = 1;
    if nargin >= 3
        interp_type = varargin{1};
    end
    [m1, m2] = ndgrid(1:outsz(1), 1:outsz(2));
    kk = (insz - 1) ./ (outsz - 1);
    dd = 1 - kk;
    t1 = kk(1) * m1 + dd(1);
    t2 = kk(2) * m2 + dd(2);
    T = cat(3, t1 - m1, t2 - m2);
    if interp_type == 0
        A = create_2d_bilinear_interp_matrix(T, insz);
    elseif interp_type == 1
        A = create_2d_bicubic_interp_matrix(T, insz);
    end
end