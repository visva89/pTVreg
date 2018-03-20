function D = generate_first_cyc_difference_matrix_for_image(sz, varargin)
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
ndif = 1;
spacing = [1, 1, 1];
if nargin > 1
    ndif = varargin{1};
end
if nargin > 2
    spacing = varargin{2};
end

if ndif == 1
    if numel(sz) == 1
        s1 = sz(1);
     
        K = prod(sz);
        m1 = 1 : prod(sz);
        m2 = [2 : prod(sz), 1];
        A1 = (sparse(1:K, m2, 1, K, P) - sparse(1:K, m1, 1, K, P)) / spacing(1);
        
        A = [A1];
    elseif numel(sz) == 2
        s1 = sz(1);
        s2 = sz(2);
      
        
        K = prod(sz);
        m1 = 1 : prod(sz);
        m2 = [2 : prod(sz), 1];
        A1 = (sparse(1:K, m2, 1, K, P) - sparse(1:K, m1, 1, K, P)) / spacing(1);
        
        [m1, m2] = ndgrid(1 : s1, 1 : s2);
        [mm1, mm2] = ndgrid(1 : s1, [2 : s2, 1]);
        tm = m1(:) + (m2(:) - 1) * s1;
        tp = mm1(:) + (mm2(:) - 1) * s1;
        K = numel(tp);
        A2 = (sparse(1:K, tp, 1, K, P) - sparse(1:K, tm, 1, K, P)) / spacing(2);
        A = [A1; A2];
        
    elseif numel(sz) == 3
        s1 = sz(1);
        s2 = sz(2);
        s3 = sz(3);

        [pp1, pp2, pp3] = ndgrid(1 : s1, 1 : s2, 1 : s3);
        [mm1, mm2, mm3] = ndgrid([2 : s1, 1], 1 : s2, 1 : s3);
        tp = sub2ind(sz, mm1(:), mm2(:), mm3(:));
        tm = sub2ind(sz, pp1(:), pp2(:), pp3(:));
        K = numel(tp);
        A1 = (sparse(1:K, tm, 1, K, P) - sparse(1:K, tp, 1, K, P)) / ...
            (spacing(1));

        [mm1, mm2, mm3] = ndgrid(1:s1, [2 : s2, 1], 1 : s3);
        tp = sub2ind(sz, mm1(:), mm2(:), mm3(:));
        tm = sub2ind(sz, pp1(:), pp2(:), pp3(:));
        K = numel(tp);
        A2 = (sparse(1:K, tm, 1, K, P) - sparse(1:K, tp, 1, K, P)) / ...
            (spacing(2));

        [mm1, mm2, mm3] = ndgrid(1:s1, 1:s2, [2 : s3, 1]);
        tp = sub2ind(sz, mm1(:), mm2(:), mm3(:));
        tm = sub2ind(sz, pp1(:), pp2(:), pp3(:));
        K = numel(tp);
        A3 = (sparse(1:K, tm, 1, K, P) - sparse(1:K, tp, 1, K, P)) / ...
            (spacing(3));
        A = [A1; A2; A3];
    end
elseif ndif == 2
    if numel(sz) == 2
        s1 = sz(1);
        s2 = sz(2);

        [m1, m2] = ndgrid(1 : s1-2, 1 : s2);
        tp1 = m1(:) + (m2(:) - 1) * s1;
        tp2 = (m1(:) + 2) + (m2(:) - 1) * s1;
        tm =  (m1(:) + 1) + (m2(:) - 1) * s1;
        K = numel(tp1);
        A1 = -2 * sparse(1:K, tm, 1, K, P) + sparse(1:K, tp1, 1, K, P) + ...
            sparse(1:K, tp2, 1, K, P);

        [m1, m2] = ndgrid(1 : s1, 1 : s2-2);
        tp1 = m1(:) + (m2(:) - 1) * s1;
        tp2 = m1(:) + (m2(:) + 1) * s1;
        tm = m1(:) + (m2(:)) * s1;
        K = numel(tp1);
        A2 = -2 * sparse(1:K, tm, 1, K, P) + sparse(1:K, tp1, 1, K, P) + ...
            sparse(1:K, tp2, 1, K, P);
        A = [A1; A2];
    elseif numel(sz) == 3
        s1 = sz(1);
        s2 = sz(2);
        s3 = sz(3);

        [m1, m2, m3] = ndgrid(1 : s1 - 2, 1 : s2, 1 : s3);
        tp1 = sub2ind(sz, m1(:), m2(:), m3(:));
        tp2 = sub2ind(sz, m1(:) + 2, m2(:), m3(:));
        tm  = sub2ind(sz, m1(:) + 1, m2(:), m3(:));
        K = numel(tp1);
        A1 = (sparse(1:K, tp1, 1, K, P) + sparse(1:K, tp2, 1, K, P) - ...
            2 * sparse(1:K, tm, 1, K, P)) / spacing(1)^2;

        [m1, m2, m3] = ndgrid(1 : s1, 1 : s2 - 2, 1 : s3);
        tp1 = sub2ind(sz, m1(:), m2(:), m3(:));
        tp2 = sub2ind(sz, m1(:), m2(:) + 2, m3(:));
        tm  = sub2ind(sz, m1(:), m2(:) + 1, m3(:));
        K = numel(tp1);
        A2 = (sparse(1:K, tp1, 1, K, P) + sparse(1:K, tp2, 1, K, P) - ...
            2 * sparse(1:K, tm, 1, K, P)) / spacing(2)^2;

        [m1, m2, m3] = ndgrid(1 : s1, 1 : s2, 1 : s3 - 2);
        tp1 = sub2ind(sz, m1(:), m2(:), m3(:));
        tp2 = sub2ind(sz, m1(:), m2(:), m3(:) + 2);
        tm  = sub2ind(sz, m1(:), m2(:), m3(:) + 1);
        K = numel(tp1);
        A3 = (sparse(1:K, tp1, 1, K, P) + sparse(1:K, tp2, 1, K, P) - ...
            2 * sparse(1:K, tm, 1, K, P)) / spacing(3)^2;
        A = [A1; A2; A3];
    end
end
D = A;
end


