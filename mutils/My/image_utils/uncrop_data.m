function [vols, Ts] = uncrop_data(vols_in, T_in, crp, size_orig)
    if size(crp, 1) == 2
        vols = zeros([size_orig, size(vols_in, 3)]);
        Ts = zeros([size_orig, 2, size(vols_in, 3)]);
        Ts(crp(1,1):crp(1,2), crp(2,1):crp(2,2), :, :) = T_in;
        vols(crp(1,1):crp(1,2), crp(2,1):crp(2,2), :) = vols_in;
    elseif size(crp, 1) == 3
        vols = zeros([size_orig, size(vols_in, 4)]);
        Ts = zeros([size_orig, 3, size(vols_in, 4)]);
        Ts(crp(1,1):crp(1,2), crp(2,1):crp(2,2), crp(3,1):crp(3,2), :, :) = T_in;
        vols(crp(1,1):crp(1,2), crp(2,1):crp(2,2), crp(3,1):crp(3,2), :) = vols_in;
    end
end