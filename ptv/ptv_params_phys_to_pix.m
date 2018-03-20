function Knots_pix = ptv_params_phys_to_pix(Knots, pix_resolution, K_ord)
    if K_ord == 1 || K_ord == 3 || K_ord == 3.5
        Knots_pix = conv_3d_T_from_phys_to_pix(Knots, pix_resolution);
    else
        Nd = numel(pix_resolution);
        Knots_pix = Knots;
%         size(Knots)
        Knots_pix(1:Nd, 1,1,1, :) = Knots(1:Nd, 1,1,1, :) ./ pix_resolution(:);
    end
%     Knots
%     Knots_pix
end