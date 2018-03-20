function vol = uncrop_volume(volcrop, crp, orig_size, is_transform)
d = numel(orig_size);

if d == 3
    if is_transform
        vol = zeros([orig_size, 3]);
        vol(crp(1,1):crp(1,2), crp(2,1):crp(2,2), crp(3,1):crp(3,2), :) = volcrop;
    else
        vol = zeros(orig_size);
        vol(crp(1,1):crp(1,2), crp(2,1):crp(2,2), crp(3,1):crp(3,2)) = volcrop;
    end
elseif d == 2
    if is_transform
        vol = zeros([orig_size, 2]);
        vol(crp(1,1):crp(1,2), crp(2,1):crp(2,2), :) = volcrop;
    else
        vol = zeros(orig_size);
        vol(crp(1,1):crp(1,2), crp(2,1):crp(2,2)) = volcrop;
    end
end
end