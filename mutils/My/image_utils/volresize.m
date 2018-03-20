function volr = volresize(vol, newsz, varargin)
    % volresize(vol, newsz, {interp_type}, {offset_type}
    interp_type = 1;
    if nargin >= 3
        interp_type = varargin{1};
    end
    
    use_offset = 'sample_std';
    if nargin >= 4
        use_offset = varargin{2};
    end
    
    tmp = zeros(max(newsz, size(vol))); 
    tmp(1:size(vol,1), 1:size(vol,2), 1:size(vol,3)) = vol;
    [n1, n2, n3] = ndgrid(1:size(tmp,1), 1:size(tmp,2), 1:size(tmp,3));
    k = size(vol) ./ newsz;
%     k = (size(vol)-1) ./ (newsz - 1);
    
    %yeah
    k = size(vol) ./ newsz;
    if strcmp(use_offset, 'matlab')
        d = 0.5*(1-k);
    elseif strcmp(use_offset, 'for_upsampling')
        d = 0.5 * [1,1,1];
%         d = [0,0,0];
    elseif strcmp(use_offset, 'for_upsampling_2')
        k = (size(vol) - 1) ./ (newsz - 1);
        k = size(vol)./ newsz;
        d = 1 - k;
    elseif strcmp(use_offset, 'sample_std')
        k = (newsz - 2) ./ (size(vol) - 2);
        k = (size(vol) - 1) ./ (newsz - 1);
        d = (1 - k);
     end
    
    
    T = cat(4, k(1) * n1 - n1 + d(1), k(2) * n2 - n2 + d(2), k(3) * n3 - n3  + d(3));
    
%         if any(k < 1)
%             sgm = 0.00001 + max(k - 1, 0)*1.1;
%             tmp = imgaussfilt3(tmp, sgm);
%         end
   
%     T = cat(4, (k(1)-1) * n1, (k(2)-1) * n2, (k(3)-1) * n3);
    

    volr = imdeform3(tmp, T, interp_type);
    
    volr = volr(1:newsz(1), 1:newsz(2), 1:newsz(3));
end