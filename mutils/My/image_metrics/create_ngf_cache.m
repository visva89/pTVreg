function cache = create_ngf_cache(metric, metric_param, imdef, imfix, spc, internal_dtype, fixed_mask)
    cache = [];
    deps = metric_param;
    cache.deps = deps;
    gt = 1;
    cache.gt = gt;
    
    if size(imdef, 3) > 1
        [gf1, gf2, gf3] = my_gradient(imfix, spc, 0, gt);
        sgm_f = gf1.^2 + gf2.^2 + gf3.^2 + deps;

        cache.gf1 = gf1;
        cache.gf2 = gf2;
        cache.gf3 = gf3;
        cache.sgm_f = sgm_f;
    else
        [gf1, gf2] = my_gradient(imfix, spc, 0, gt);
        sgm_f = gf1.^2 + gf2.^2 + deps;

        cache.gf1 = gf1;
        cache.gf2 = gf2;
        cache.sgm_f = sgm_f;
    end
end