function [err, g, perr] = metric_ngf(imfix, imdef, spc, cache)
   
   Nd = 2;
   gt = 1;
   deps = 1e-3;
   deps = 1e-1;
%    spc = [1, 1, 1];
%    spc = cache.spacing;
   dvol = prod(spc);
    if ~isempty(cache)
        deps = cache.deps;
    end

   if size(imfix, 3) > 1
       Nd = 3;
   end
   
   if Nd == 3
        if ~isempty(cache)
            gf1 = cache.gf1;
            gf2 = cache.gf2;
            gf3 = cache.gf3;
            sgm_f = cache.sgm_f;
        else
            [gf1, gf2, gf3] = my_gradient(imfix, spc, 0, gt);
            sgm_f = gf1.^2 + gf2.^2 + gf3.^2 + deps;
        end
        [gm1, gm2, gm3] = my_gradient(imdef, spc, 0, gt);
        sgm_m = gm1.^2 + gm2.^2 + gm3.^2 + deps;
        c = gf1.*gm1 + gf2.*gm2 + gf3.*gm3 + deps;
        
        perr = 1 - c./(sgm_f.*sgm_m);
        err = sum(fl( perr )) * (dvol);
        denom = 1./(sgm_m.^2 .* sgm_f);
        tmp1 = (gf1.*sgm_m - 2 .* c .* gm1) .* denom;
        tmp2 = (gf2.*sgm_m - 2 .* c .* gm2) .* denom;
        tmp3 = (gf3.*sgm_m - 2 .* c .* gm3) .* denom;

        g =    my_gradient(tmp1, spc, 1, gt) + ...
               my_gradient(tmp2, spc, 2, gt) + ...
               my_gradient(tmp3, spc, 3, gt);
        g = g * (-dvol);
%         imagesc(g(:,:, round(end/2)));  colorbar; pause(0.1);
   elseif Nd = 2;
       if ~isempty(cache)
            gf1 = cache.gf1;
            gf2 = cache.gf2;
            sgm_f = cache.sgm_f;
        else
            [gf1, gf2] = my_gradient(imfix, spc, 0, gt);
            sgm_f = gf1.^2 + gf2.^2 + deps;
        end
        [gm1, gm2] = my_gradient(imdef, spc, 0, gt);
        sgm_m = gm1.^2 + gm2.^2 + deps;
        c = gf1.*gm1 + gf2.*gm2 + deps;
        
        perr = 1 - c./(sgm_f.*sgm_m);
        err = sum(fl( perr )) * (dvol);
        denom = 1./(sgm_m.^2 .* sgm_f);
        tmp1 = (gf1.*sgm_m - 2 .* c .* gm1) .* denom;
        tmp2 = (gf2.*sgm_m - 2 .* c .* gm2) .* denom;
        g =    my_gradient(tmp1, spc, 1, gt) + ...
               my_gradient(tmp2, spc, 2, gt);
        g = g * (-dvol);
   end
end