function x = next_good_factorization(a, max_factor)
% finds x > a such that abs(a-x)->min s.t. all(factor(x) <= max_factor)
% ugly solution 
    while true
        f = factor(a);
        if any(f > max_factor)
            a = a + 1;
        else
            break;
        end
    end
    x = a;
end

