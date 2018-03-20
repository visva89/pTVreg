function grid_sz = ptv_get_grid_size(imsz, grid_sp, K_ord)
%
    imsz = imsz(1:min(numel(imsz), numel(grid_sp)));
    grid_sp = grid_sp(1:min(numel(imsz), numel(grid_sp)));
    if K_ord == 1
        grid_sz = ceil(imsz ./ grid_sp) + 1;
    elseif K_ord == 3
        grid_sz = ceil(imsz ./ grid_sp) + 3;
    elseif K_ord == 3.5
        grid_sz = ceil(imsz ./ grid_sp);
        
    elseif K_ord == -1 % translate
        if size(imsz, 3) > 1
            grid_sz = [3,1,1];
        else
            grid_sz = [2,1,1];
        end
    elseif K_ord == -2 % rigid 
        if size(imsz, 3) > 1
            grid_sz = [6,1,1];
        else
            grid_sz = [3,1,1];
        end
    elseif K_ord == -3 % rigid scale
        if size(imsz, 3) > 1
            grid_sz = [7,1,1];
        else
            grid_sz = [4,1,1];
        end
    elseif K_ord == -4 % affine
        if size(imsz, 3) > 1
            grid_sz = [7,1,1];
        else
            grid_sz = [6,1,1];
        end        
    else
        error('Unknown K_ord\n');
    end
    
    if numel(imsz) == 2 || imsz(3) == 1 
        grid_sz(3) = 1;
    end
end