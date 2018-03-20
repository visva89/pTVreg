function M = ptv_params_to_matrix(params, transform_type)
    if isnumeric(transform_type)
        if transform_type == -1
            transform_type = 'translate';
        elseif transform_type == -2
            transform_type = 'rigid';
        elseif transform_type == -3
            transform_type = 'rigid_scale';
        elseif transform_type == -4
            transform_type = 'affine';
        end
    end
    
    
    if strcmp(transform_type, 'affine')
        M = [1 + params(3), params(4), params(1); ...
          params(5), 1 + params(6), params(2)];
    elseif strcmp(transform_type, 'rigid')
        theta = params(3);
        M = [cos(theta), -sin(theta), params(1); ...
             sin(theta), cos(theta), params(2)];
    elseif strcmp(transform_type, 'rigid_scale')
        theta = params(3);
        scale = 1 + params(4);
        M = [cos(theta) * scale, -sin(theta) * scale, params(1); ...
             sin(theta) * scale, cos(theta) * scale, params(2)];
    elseif strcmp(transform_type, 'translate')
        M = [1, 0, params(1); ...
             0, 1, params(2)];
    end
end