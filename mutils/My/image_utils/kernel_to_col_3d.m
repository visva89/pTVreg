function v = kernel_to_col_3d(K, imsz)
%% converts kernel K to vector, such as 
%% it can be stacked into cyclic matrix
% vv = zeros(imsz);
% vv(1:size(K,1), 1:size(K,2), 1:size(K,3)) = K;
% vv = circshift(vv, -floor(size(K, 3)/2), 3);
% vv = circshift(vv, -floor(size(K, 2)/2), 2);
% vv = circshift(vv, -floor(size(K, 1)/2), 1);
% sliceomatic(vv)
% pause;

v = zeros(prod(imsz), 1);
for j = 1 : size(K, 3)
    LL = (j - 1) * imsz(2) * imsz(1);
%     RR = 1 + (j - 1) * imsz(1) * imsz(2) + ;
    for i = 1 : size(K, 2)
        L = 1 + (i - 1) * imsz(1) + LL;
        R = L - 1 + size(K, 1);
        v(L:R) = K(:, i, j);
    end
end
s = (size(K, 3)-1)/2 *imsz(1)*imsz(2) + (size(K, 2) - 1)/2 * imsz(1) + (size(K, 1) -1)/2;
v  = circshift(v, [-s, 1]);
end
    
