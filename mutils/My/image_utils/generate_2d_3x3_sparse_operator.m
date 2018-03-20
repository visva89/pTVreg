function D = generate_2d_3x3_sparse_operator(mat, sz)
% D = generate_first_difference_matrix_for_image(sz, {dif_order, spacing})
% sz -- image size 2x1 or 3x1
% dif_order -- 1 or 2. 1st or 2nd derivative
% spacing -- size of pixel in physical units. 2x1 or 3x1
%
% Creates derivative matrix, if IMG is rect. image or volume, then
% G = D * IMG(:); 
% G is [prod(size(IMG))*ndims]x[1] vector, containing drivatives in 
% 1, 2, {3} directions.
%
    P = prod(sz);
    s1 = sz(1);
    s2 = sz(2);

    [m1, m2] = ndgrid([1 : s1-1, 1], 1 : s2);
    tp = m1(:) + (m2(:) - 1) * s1;
    tm = (m1(:)+1) + (m2(:) - 1) * s1;
    K = numel(tp);
    A1 = (sparse(1:K, tm, 1, K, P) - sparse(1:K, tp, 1, K, P)) / spacing(1);

    [m1, m2] = ndgrid(1 : s1, [1 : s2-1, 1]);
    tp = m1(:) + (m2(:) - 1) * s1;
    tm = m1(:) + (m2(:)) * s1;
    K = numel(tp);
    A2 = (sparse(1:K, tm, 1, K, P) - sparse(1:K, tp, 1, K, P)) / spacing(2);
    A = [A1; A2];
end

