function pyr = create_image_pyramid(img, type)
pyr = {};
pyr{1} = img;
N = floor(log( min(size(pyr{1})))/log(2));

if strcmp(type, 'box')
    if ndims(img) == 2
        for i = 1 : N
            tmp = pyr{i};
            if mod(size(tmp, 1), 2) ~= 0
                tmp = [tmp; tmp(end, :)];
            end
            if mod(size(tmp, 2), 2) ~= 0
                tmp = [tmp, tmp(:, end)];
            end
            tmp(:, 1:2:end-1) = tmp(:, 1:2:end-1) + tmp(:, 2:2:end);
            tmp(1:2:end-1, :) = tmp(1:2:end-1, :) + tmp(2:2:end, :);
            tmp = tmp(1:2:end-1, 1:2:end-1)/4;
            pyr{i+1} = tmp;
        end
    elseif ndims(img) == 3
        for i = 1 : N
            tmp = pyr{i};
            if mod(size(tmp, 1), 2) ~= 0
                tmp = [tmp; tmp(end, :, :)];
            end
            if mod(size(tmp, 2), 2) ~= 0
                tmp = [tmp, tmp(:, end, :)];
            end
            if mod(size(tmp, 3), 2) ~= 0
                tmp = cat(3, tmp, tmp(:, :, end));
            end
            tmp(:, :, 1:2:end-1) = tmp(:, :, 1:2:end-1) + tmp(:, :, 2:2:end);
            tmp(:, 1:2:end-1, :) = tmp(:, 1:2:end-1, :) + tmp(:, 2:2:end, :);
            tmp(1:2:end-1, :, :) = tmp(1:2:end-1, :, :) + tmp(2:2:end, :, :);
            tmp = tmp(1:2:end-1, 1:2:end-1, 1:2:end-1)/8;
            pyr{i+1} = tmp;
        end
    end
elseif strcmp(type, 'gauss_const')
    if ndims(img) == 3
        for i = 1 : N
            tmp = pyr{1};
            tmp = imgaussfilt3(tmp, (2^i)/2);
            pyr{i+1} = tmp;
        end
    end
end
 end