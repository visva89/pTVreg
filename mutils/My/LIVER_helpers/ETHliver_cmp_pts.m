% function [pmoved, TREs] = ETHliver_cmp_pts(T, pmov, pfix, pix_resolution)
%     koef = repmat(pix_resolution', [1, size(pmov, 2)]);
%     pmov = pmov ./ koef;
%     pfix = pfix ./ koef;
%     pmoved = simple_move_points(pmov', T, ones(3,1))';
%     TREs = sqrt(sum(((pmoved - pfix).*koef).^2, 1));
% end

function [pmoved, TREs] = ETHliver_cmp_pts(T, pfix, pmov, pix_resolution)
%     pmoved = move_points_lerp_phys(pmov', T, pix_resolution, ones(3,1));
    pmoved = move_points_phys(pfix', T, pix_resolution, ones(3,1));
    pmoved = pmoved';
    TREs = sqrt(sum((pmoved - pmov).^2, 1));
end