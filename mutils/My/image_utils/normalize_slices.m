function [imgs_norm, maxpf] = normalize_slices(imgs)
    if ndims(imgs) == 3
        maxpf= max(max(imgs, [], 1), [], 2);
    elseif ndims(imgs) == 4
        maxpf= max(max(max(imgs, [], 1), [], 2), [], 3);
    end
    imgs_norm = bsxfun(@rdivide, imgs, maxpf);
end