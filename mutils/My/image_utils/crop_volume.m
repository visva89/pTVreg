function volcrop = crop_volume(vol, crp)
if ndims(vol) == 3
    volcrop = vol(crp(1,1):crp(1,2), crp(2,1):crp(2,2), crp(3,1):crp(3,2));
elseif ndims(vol) == 2
    volcrop = vol(crp(1,1):crp(1,2), crp(2,1):crp(2,2));
end
end