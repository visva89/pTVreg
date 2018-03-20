function vols = crop_data(vols_in, crp)
    if size(crp, 1) == 2
        vols = vols_in(crp(1,1):crp(1,2), crp(2,1):crp(2,2), :);
    elseif size(crp, 1) == 3
        vols = vols_in(crp(1,1):crp(1,2), crp(2,1):crp(2,2), crp(3,1):crp(3,2), :);
    end
end