function gauss = get_gauss_kernel_by_sigma(sigma, d)
% generate gaussian kernel with given pixel resolution, 
% parameter d controls nonsingular dimensions.     
    wd = round(8 * max(sigma));
    N = round((wd-1)/2);
    x = -N:N;
    size(x)
    
    ndims = numel(sigma);
    
    y = cell(ndims, 1);
    for i = 1 : ndims
        y{i} = 1/(sqrt(2*pi)*sigma(i)) * exp( - (x).^2/(2*sigma(i)^2) );
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
    size(K)
    N
    
    gauss = K / sum(K(:));
end