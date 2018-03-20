function [err, g] = metric_logssd(vol_fix, voldef, dvol)
    vol_diff = voldef - vol_fix;
    vdsq = vol_diff.^2;
    err = log(1 + sum(sum(sum(vdsq)))) * dvol;
    g = 2 * vol_diff ./ (1 + vdsq) * dvol;
end