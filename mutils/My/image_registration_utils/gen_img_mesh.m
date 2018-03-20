function img = gen_img_mesh(size, res)
    img = zeros(size);
    qs = 1 : res : size(1);
    for i = 1 : numel(qs)
%         qs(i)
        img(ceil(qs(i)), :) = 1;
    end
    qs = 1 : res : size(2);
    for i = 1 : numel(qs)
        img(:, ceil(qs(i))) = 1;
    end
    img(end, :) = 1;
    img(:, end) = 1;
end