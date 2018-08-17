function alpha = fit_rotation_2d(D, mask, center)
    
    D1 = D(:,:,1);
    D2 = D(:,:,2);
    [x1, x2] = ind2sub(size(mask), find(mask));
    x1 = x1 - center(1);
    x2 = x2 - center(2);
    d1 = D1(mask);
    d2 = D2(mask);
    fobj = @(x) fg(x, x1, x2, d1, d2);
    opts = [];
    opts.display = 'off';
    opts.progTol = 1e-15;
    opts.optTol = 1e-15;
    alpha = minFunc(fobj, 0, opts);
end

function [e, g] = fg(alpha, x1, x2, d1, d2)
    d = 0.0000001;
    e = fx(alpha, x1,x2,d1,d2);
    ee = fx(alpha+d, x1,x2,d1,d2);
    g = (ee - e) / d;
end

function err = fx(alpha, x1, x2, d1, d2)
    err = 0;
    R = [cos(alpha), -sin(alpha); ...
         sin(alpha),  cos(alpha);];
    p = R * [x1(:)'; x2(:)'];
    err = err + sum(sum( sqrt( (p(1, :)' - x1 - d1).^2 + (p(2, :)' - x2 - d2).^2 ) ));
end