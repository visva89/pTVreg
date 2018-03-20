function mask = create_pad_mask(imsz, pad)
    if numel(pad) == 1
        pad = pad * ones(imsz);
    end
    
    if ndims(imsz) == 2
        mask = ones(imsz);
        mask(1:pad(1), :) = 0;
        mask(end-pad(1)+1:end,:) = 0;
        mask(:, 1:pad(2)) = 0;
        mask(:, end-pad(2)+1:end) = 0;
    end
end