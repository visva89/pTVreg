function imrsz =  image_resize(img, rsz)
    nd = ndims(img);
    if numel(rsz) == 1
        rsz = rsz * ones(1, nd);
    end
    if nd == 2
        tform = affine2d([rsz(1) 0 0 ; 0 rsz(2) 0 ; 0 0 1]);
    elseif nd == 3
        tform = affine3d([rsz(1) 0 0 0; 0 rsz(2) 0 0; 0 0 rsz(3) 0; 0 0 0 1]);
    end
    
    imrsz = imwarp(img, tform, 'cubic');
%     imrsz = imwarp(img, tform, 'cubic', 'SmoothEdges', false);
%     if nd == 3
%         imrsz = imwarp(img, tform, 'linear', 'SmoothEdges', true);
%     end
end