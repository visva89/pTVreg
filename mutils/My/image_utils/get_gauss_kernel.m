function gauss = get_gauss_kernel(N, pix_resolution, d)
% generate gaussian kernel with given pixel resolution, 
% parameter d controls nonsingular dimensions.     
    spc2 = pix_resolution / min(pix_resolution);
%     spc2 = pix_resolution ./ pix_resolution;
    sigma = (2 * N + 1) / 3;
    N = ceil(N);
    x = linspace(-2.5 * sigma, 2.5 * sigma, 2 * N + 1);
%     x = linspace(-4.5 * sigma, 4.5 * sigma, 2 * N + 1);

    ndims = numel(pix_resolution);
    y = cell(ndims, 1);
    for i = 1 : ndims
        y{i} = 1/(sqrt(2*pi)*sigma) * exp( - (x*spc2(i)).^2/(2*sigma^2) );
        if d(i) == 0
            y{i} = y{i}*0;
            y{i}((numel(y{i}) - 1)/2 + 1) = 1;
        end
    end
    
    if ndims == 2
%         K = y{2}' * y{1};
        K = y{1}' * y{2};
    elseif ndims == 3
        t = y{1}' * y{2};
        K = zeros((2*N+1)*[1,1,1]);
        for i = 1 : 2*N+1
            K(:,:,i) = t * y{3}(i);
        end
    end
    gauss = K / sum(K(:));
end