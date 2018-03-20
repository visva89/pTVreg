function [err, grad] = det_regularization_v1(Knots, kspc, min_j, max_j)
    err = 0;
    grad = zeros(size(Knots), 'like', Knots);
    Nd = size(Knots, 4);
    kspc = kspc(1:Nd);
    gvol = prod(kspc);
   
    if Nd == 3
        for i = 1 : size(Knots, 5)
            [g11, g12, g13] = my_gradient(Knots(:,:, :, 1), kspc);
            [g21, g22, g23] = my_gradient(Knots(:,:, :, 2), kspc);
            [g31, g32, g33] = my_gradient(Knots(:,:, :, 3), kspc);
            g11 = g11 + 1;
            g22 = g22 + 1;
            g33 = g33 + 1;
            det = g11.*g22.*g33 + g21.*g32.*g13 + g12.*g23.*g31 - ...
                  g31.*g22.*g13 - g21.*g12.*g33 - g32.*g23.*g11;
            
            [p_v, p_g] = L_g2(det, min_j, max_j);
            err = sum(p_v(:)) * gvol;
            e_g = p_g * gvol;

            grad(:,:, :, 1, i) = my_gradient(e_g .* (g22 .* g33 - g23 .* g32), kspc, 1) + ...
                              my_gradient(e_g .* (g31 .* g23 - g21 .* g33), kspc, 2) + ...
                              my_gradient(e_g .* (g21 .* g32 - g31 .* g22), kspc, 3);
            grad(:,:, :, 2, i) = my_gradient(e_g .* (g32 .* g13 - g12 .* g33), kspc, 1) + ...
                              my_gradient(e_g .* (g11 .* g33 - g31 .* g13), kspc, 2) + ...
                              my_gradient(e_g .* (g31 .* g12 - g11 .* g32), kspc, 3);
            grad(:,:, :, 3, i) = my_gradient(e_g .* (g12 .* g23 - g22 .* g13), kspc, 1) + ...
                              my_gradient(e_g .* (g21 .* g13 - g11 .* g23), kspc, 2) + ...
                              my_gradient(e_g .* (g11 .* g22 - g21 .* g12), kspc, 3);
        end
    elseif Nd == 2
        for i = 1 : size(Knots, 5)
            [g11, g12] = my_gradient(Knots(:,:, 1, 1), kspc);
            [g21, g22] = my_gradient(Knots(:,:, 1, 2), kspc);
            g11 = g11 + 1;
            g22 = g22 + 1;
            det = g11.*g22 - g21.*g12;

            [p_v, p_g] = L_g2(det, min_j, max_j);
            err = sum(p_v(:)) * gvol;
            e_g = p_g * gvol;

            grad(:,:, 1, 1, i) = my_gradient(e_g .* g22, kspc, 1) + ...
                                 my_gradient(e_g .* g21, kspc, 2);
            grad(:,:, 1, 2, i) =-my_gradient(e_g .* g12, kspc, 1) + ...
                                 my_gradient(e_g .* g11, kspc, 2);
        end
    end
%     err
end

function g = L_gg(x, min_j, max_j)
    g = zeros(size(x), 'like', x);
    g(x>max_j) =  1;
    g(x<min_j) = -1;
end

function [f, g] = L_g1(x, min_j, max_j)
    f = max(max(x - max_j, -x + min_j), 0);
    g = zeros(size(x), 'like', x);
    g(x>max_j) =  1;
    g(x<min_j) = -1;
end

function [f, g] = L_g2(x, min_j, max_j)
    idxs1 = x < min_j;
    idxs2 = x > max_j;
    g = zeros(size(x), 'like', x);
    f = sum((x(idxs1)-min_j).^2)/2  + sum((x(idxs2)-max_j).^2)/2;
    g(idxs1) = x(idxs1) - min_j;
    g(idxs2) = x(idxs2) - max_j;
end