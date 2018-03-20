function [volsz, Nd, Nch, Nimgs] = ptv_get_sizes_from_volsz(sz)
    if numel(sz) == 2
        volsz = sz;
        Nch = 1;
        Nd = 2;
        Nimgs = 1;
    elseif numel(sz) == 3
        volsz = sz;
        Nch = 1;
        Nd = 3;
        Nimgs = 1;
    elseif numel(sz) == 4 || numel(sz) == 5
        volsz = sz(1:3);
        if sz(3) == 1
            Nd = 2;
        else
            Nd = 3;
        end
        Nch = sz(4);
        Nimgs = 1;
        if numel(sz) == 5
            Nimgs = sz(5);
        end
    end
end