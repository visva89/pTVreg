function imgs = create_pyramid(img, nlevels)
    h = fspecial('gaussian', [7 7], 0.7);
    imgs = cell(nlevels, 1);
    imgs{nlevels} = img;
    for i = nlevels-1 :-1: 1
        t = imfilter(imgs{i+1}, h, 'replicate');
        imgs{i} = t(1:2:end, 1:2:end, :);
%         imgs{i} = imresize(imgs{i+1}, 0.5);
    end
end