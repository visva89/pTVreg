function imdef = imdeform_mipmap(imp, Tpix, type)
    imdef = imp{1} * 0;
    if ndims(imp{1}) == 3
        npyr = numel(imp);
        [g11,g12,g13] = mex_my_gradient_3d_double(Tpix(:,:,:,1));
        [g21,g22,g23] = mex_my_gradient_3d_double(Tpix(:,:,:,2));
        [g31,g32,g33] = mex_my_gradient_3d_double(Tpix(:,:,:,3));
        g11 = g11 + 1;
        g22 = g22 + 1;
        g33 = g33 + 1;
        det = g11.*g22.*g33 + g12.*g23.*g31 + g21.*g32.*g13 - g31.*g22.*g13 - g21.*g12.*g33 - g32.*g23.*g11;
        
        d = sqrt(abs(det));
        d = d + 1e-10;
        t = log(d) / log(2);
        
        t = max(t, 0);
        t = min(t, npyr);
        tf = floor(t);
        tc = ceil(t);
        
        alpha = t - tf;
        

        imdp = zeros([size(imp{1}), npyr]);
        imd1 = imdeform(imp{1}, Tpix, type);
        for i = 1 : npyr-1
            ii = i - 1;
            imd2 = imdeform(imp{i+1}, Tpix, type);
            imdef(tf == ii) = (1-alpha(tf==ii)) .* imd1(tf==ii) + alpha(tf==ii) .* imd2(tf==ii);
            imd1 = imd2;
        end
       
        
    end
end