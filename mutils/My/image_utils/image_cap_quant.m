function img = image_cap_quant(img, k, klower)
    for i = 1 : size(img, 5)
        tmp = img(:,:,:,:, i);
        sorted = sort(tmp(:), 'ascend');
        thrval = sorted(round(k * end));
        tmp(tmp > thrval) = thrval;
        
        thrval = sorted(round(klower * end));
        tmp(tmp < thrval) = thrval;
        
        img(:,:,:,:, i) = tmp;
    end
end