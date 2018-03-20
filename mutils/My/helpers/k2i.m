function img = k2i(img, dims)

dim_img = size(img);

if nargin < 2
    factor  = prod(dim_img);
    img = sqrt(factor)*fftshift( ifftn(ifftshift(img)) );
%     img = fftshift( ifftn(ifftshift(img)) );
else
    for dim = dims
        img = sqrt(dim_img(dim))*fftshift( ifft(ifftshift(img,dim),[],dim), dim);
%         img = fftshift( ifft(ifftshift(img,dim),[],dim), dim);
    end
end

end