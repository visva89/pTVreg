function gauss = get_gaussian_kernel(Nsigmas, sigma_in_pix)
% generate gaussian kernel with given sigmas
    ndims = numel(sigma_in_pix);
    width = 2 * floor(Nsigmas .* sigma_in_pix) + 1;
    hw = (width - 1)/2;
    
    sigma_in_pix(sigma_in_pix == 0) = 1;
    if ndims == 3
        -hw(1):hw(1)
        hw(2)
        hw(3)
        [n1, n2, n3] = ndgrid(-hw(1):hw(1), -hw(2):hw(2), -hw(3):hw(3));
        size(n1)
        weight = exp(-n1.^2/(2*sigma_in_pix(1)^2) - n2.^2/(2*sigma_in_pix(2)^2) - n3.^2/(2*sigma_in_pix(3)^2) );
    elseif ndims == 2
        [n1, n2] = ndgrid(-hw(1):hw(1), -hw(2):hw(2));
        weight = exp(-n1.^2/(2*sigma_in_pix(1)^2) - n2.^2/(2*sigma_in_pix(2)^2));
    end
    
    gauss = weight / sum(weight(:));
end