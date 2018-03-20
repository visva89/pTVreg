function [g] = interm_grad(img, dir, conj, spc)
% gradient of the image in direction dir. Fwd difference is used.
% result is equivalent to D*img(:), where D is cyclic finite difference
% matrix.
% conj is true if we need D'*img(:)
% img can be 2d or 3d
% spc is spacing

    if isempty(spc)
        spc = [1, 1, 1];
    end
    if ~isempty(conj) && conj
        imgs = circshift(img, 1, dir);
        if ndims(img) == 2
            if dir == 1
                imgs(1, :) = img(1, :);
            elseif dir == 2
                imgs(:, 1) = img(:, 1);
            end
        elseif ndims(img) == 3
            if dir == 1
                imgs(1, :, :) = img(1, :, :);
            elseif dir == 2
                imgs(:, 1, :) = img(:, 1, :);
            elseif dir == 3
                imgs(:, :, 1) = img(:, :, 1);
            end
        end
        g = (imgs - img)/spc(dir);
    else
        imgs = circshift(img, -1, dir);
        if ndims(img) == 2
            if dir == 1
                imgs(end, :) = img(end, :);
            elseif dir == 2
                imgs(:, end) = img(:, end);
            end
        elseif ndims(img) == 3
            if dir == 1
                imgs(end, :, :) = img(end, :, :);
            elseif dir == 2
                imgs(:, end, :) = img(:, end, :);
            elseif dir == 3
                imgs(:, :, end) = img(:, :, end);
            end
        end
        g = (imgs - img)/spc(dir);
    end
    
end
