% function [err, g, perr] = metric_sad(imfix, imdef, dvol)
%     vol_diff = imdef - imfix;
%     err = sum(sum(sum(abs(vol_diff))))* dvol;
%     g = sign(vol_diff) * dvol;
%     perr = vol_diff * dvol;
% end

function [err, g, perr] = metric_sad(imfix, imdef, dvol, mask)
    if isempty(mask)
        vol_diff = (imdef - imfix);
        err = sum(sum(sum(sum(sum( abs(vol_diff) ))))) * dvol;
        g = sign(vol_diff) * dvol;
        perr = vol_diff * dvol;
    else
        vol_diff = (imdef - imfix);
        amask = bsxfun(@times, abs(vol_diff), mask);        
        err = sum(amask(:)) * dvol;
        g = bsxfun(@times, sign(vol_diff), mask) * dvol;
        perr = amask * dvol;
    end
end