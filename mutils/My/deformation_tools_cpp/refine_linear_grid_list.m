function [Knots_n] = refine_linear_grid_list(Knots, old_spacing, ds, volsz, varargin)
    k_down = 0.5;
%     new_vol_sz = [];
    if nargin >= 5
        k_down = varargin{1};
    end
    
    nd = numel(ds);
    if nd == 2
        Knots_sz = ceil(volsz ./ old_spacing) + 1;
        Knots_n = zeros([Knots_sz, 2, size(Knots, 4)]);
        for i = 1 : size(Knots, 4)
            Knots_n(:,:,:, i) = refine_linear_grid_2d(Knots(:,:,:, i), old_spacing, ds, volsz, k_down);
        end
    elseif nd == 3
        Knots_sz = ceil(volsz ./ old_spacing) + 1;
        Knots_n = zeros([Knots_sz, 3, size(Knots, 5)]);
        for i = 1 : size(Knots, 5)
            Knots_n(:,:,:,:, i) = refine_linear_grid_3d(Knots(:,:,:,:, i), old_spacing, ds, volsz, k_down);
        end
    end
end