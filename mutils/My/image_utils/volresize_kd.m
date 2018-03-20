function volr = volresize_kd(vol, k, d, interp_type)
    % volresize(vol, newsz, {interp_type}, {offset_type}
    Nd = 3;
    if size(vol, 3) == 1
        Nd = 2;
    end
    
    if numel(k) == 1
        k = k * ones(1, Nd);
    end
    if numel(d) == 1
        d = d * ones(1, Nd);
    end
    
    newsz = ceil(size(vol) ./ k);
    
    tmp = zeros(max(newsz, size(vol))); 
    tmp(1:size(vol,1), 1:size(vol,2), 1:size(vol,3)) = vol;
    
    if Nd == 3
        [n1, n2, n3] = ndgrid(1:size(tmp,1), 1:size(tmp,2), 1:size(tmp,3));
        T = cat(4, k(1) * n1 - n1 + d(1), k(2) * n2 - n2 + d(2), k(3) * n3 - n3  + d(3));
        volr = imdeform3(tmp, T, interp_type);    
        volr = volr(1:newsz(1), 1:newsz(2), 1:newsz(3));
    elseif Nd == 2
        [n1, n2] = ndgrid(1:size(tmp,1), 1:size(tmp,2));
        T = cat(3, k(1) * n1 - n1 + d(1), k(2) * n2 - n2 + d(2));
        volr = imdeform2(tmp, T, interp_type);    
        volr = volr(1:newsz(1), 1:newsz(2));
    end
end