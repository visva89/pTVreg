function ret = ptv_fix_nd_size(x, nd)
    if nd == 1
        error('1d registration is not supported');
    elseif nd == 2
        if numel(x) == 1
            ret = [x, x, 1];
        elseif numel(x) == 2
            ret = [x(1), x(2), 1];
        else
            x(3) = 1;
            ret = x(1:3);
        end
    elseif nd == 3
        if numel(x) == 1
            ret = [x, x, x];
        else
            ret = x(1:3);
        end
    else
        error('nd should be 2 or 3');
    end

end