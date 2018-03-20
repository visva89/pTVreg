function A = create_3d_image_upsample_matrix(insz, outsz, varargin)
    % (insz, outsz, {interp_type})
    interp_type = 1;
    if nargin >= 3
        interp_type = varargin{1};
    end
    if numel(outsz) == 2
        outsz(3) = 1;
    end
    [m1, m2, m3] = ndgrid(1:outsz(1), 1:outsz(2), 1:outsz(3));
    kk = (insz - 1) ./ (outsz - 1);
    kk(isnan(kk)) = 1;
    kk(isinf(kk)) = 1;
    dd = 1 - kk;
    t1 = kk(1) * m1 + dd(1);
    t2 = kk(2) * m2 + dd(2);
    t3 = kk(3) * m3 + dd(3);
    T = cat(4, t1 - m1, t2 - m2, t3 - m3);

    if interp_type == 0
        A = create_3d_linear_interp_matrix(T, insz);
    elseif interp_type == 1
        A = create_3d_cubic_interp_matrix(T, insz);
    end
end