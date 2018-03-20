function v = kernel_to_col_2d(K, imsz)
%% converts kernel K to vector, such as 
%% it can be stacked into cyclic matrix
% if nnz(size(K) ~= imsz) == 0
%     v = K(:);
% end

v = zeros(prod(imsz), 1);
for i = 1 : size(K, 2)
    L = 1 + (i - 1) * imsz(1);
    R = 1 + (i - 1) * imsz(1) + size(K, 1) - 1;
    v(L:R) = K(:, i);
end
s = (size(K, 1) - 1)/2 * imsz(1) + (size(K, 2) - 1)/2;
% s = (size(K, 2) - 1)/2 * imsz(1) + (size(K, 1) - 1)/2;

s = floor(s);
v  = circshift(v, [-s, 1]);

end
    
