function volr = volresize_t2(vol, k, varargin)
    % volresize(vol, k, {interp_type}
    interp_type = 1;
    if nargin >= 3
        interp_type = varargin{1};
    end
    if numel(k) == 1
        k = k * [1,1,1];
    end
    
    newsz = round(k.*size(vol));
    
    tmp = zeros(max(newsz, size(vol))); 
    tmp(1:size(vol,1), 1:size(vol,2), 1:size(vol,3)) = vol;
    [n1, n2, n3] = ndgrid(1:size(tmp,1), 1:size(tmp,2), 1:size(tmp,3));
    
    k=1./k;
    d = 1 - k;
    T = cat(4, k(1) * n1 - n1 + d(1), k(2) * n2 - n2 + d(2), k(3) * n3 - n3  + d(3));
   

    volr = imdeform3(tmp, T, interp_type);
    
    volr = volr(1:newsz(1), 1:newsz(2), 1:newsz(3));
end