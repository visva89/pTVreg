function img = i2k(img, dims)

dim_img = size(img);

if nargin < 2
    factor  = prod(dim_img);
    img = 1/sqrt(factor)*fftshift(fftn(ifftshift( img )));
%     img = fftshift(fftn(ifftshift( img )));
else
    for dim = dims
        img = 1/sqrt(dim_img(dim))*fftshift(fft(ifftshift( img, dim ),[],dim),dim);
%         img = fftshift(fft(ifftshift( img, dim ),[],dim),dim);
    end
end

end
