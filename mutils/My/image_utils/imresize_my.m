function imgr = imresize_my(img, newsz, varargin)
    % volresize(vol, newsz, {interp_type}, {offset_type}
    interp_type = 1;
    if nargin >= 3
        interp_type = varargin{1};
    end
    
    use_offset = 'sample_std';
    if nargin >= 4
        use_offset = varargin{2};
    end
    
    if all( (size(img) ./ newsz) > 1.5 )
        img = imgaussfilt(img, (size(img) ./ newsz)/2.5 );
    end
    
    tmp = zeros(max(newsz, size(img))); 
    tmp(1:size(img,1), 1:size(img,2)) = img;
    [n1, n2] = ndgrid(1:size(tmp,1), 1:size(tmp,2));
    k = size(img) ./ newsz;
    if strcmp(use_offset, 'matlab')
        d = 0.5*(1-k);
    elseif strcmp(use_offset, 'for_upsampling')
        d = 0.5 * [1,1];
%         d = [0,0,0];
    elseif strcmp(use_offset, 'for_upsampling_2')
        k = (size(img) - 1) ./ (newsz - 1);
        k = size(img)./ newsz;
        d = 1 - k;
    elseif strcmp(use_offset, 'sample_std')
        k = (size(img) - 1) ./ (newsz - 1);
        d = (1 - k);
     end
    T = cat(3, k(1) * n1 - n1 + d(1), k(2) * n2 - n2 + d(2));
    
    imgr = imdeform2(tmp, T, interp_type);
    imgr = imgr(1:newsz(1), 1:newsz(2));
end