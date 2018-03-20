function [err, g, perr] = metric_ssd(imfix, imdef, dvol, mask)
   
    if isempty(mask)
        vol_diff = (imdef - imfix);
        err = sum(sum(sum(sum(sum(vol_diff.^2))))) * dvol/2;
        g = vol_diff * dvol;
        perr = vol_diff * dvol;
    else
        vol_diff = (imdef - imfix);
        err = sum(sum(sum(sum(mask .* vol_diff.^2 )))) * dvol/2;
        g = bsxfun(@times, vol_diff, mask) * dvol;
        perr = mask .* vol_diff * dvol;
    end
end