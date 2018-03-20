function [imdef, grad] = imdeform2_and_grad(imfix, T, varargin) %, interp_type, out_type, out_val, pix_resolution)
% deform image
    interp_type = 0;
    out_type = 0;
    out_val = 0;
    pix_resolution = [1,1];
    
    if nargin >= 3
        if ~isempty(varargin{1})
            interp_type = varargin{1};
        end
    end
    if nargin >= 4
        if ~isempty(varargin{2})
            out_type = varargin{2};
        end
    end
    if nargin >= 5
        if ~isempty(varargin{3})
            out_val = varargin{3};
        end
    end
    if nargin >= 6 
        if ~isempty(varargin{4})
            pix_resolution = varargin{4};
            T = conv_2d_T_from_phys_to_pix(T, pix_resolution);
        end
    end
    
    if size(imfix, 1) ~= size(T, 1) || size(imfix, 2) ~= size(T, 2) || size(T, 3) ~= 2
        size(imfix)
        size(T)
        error('Dimensions dont match');
    end
    
    if isa(imfix, 'single') && isa(T, 'single')
        [imdef, grad] = mex_2d_image_warp_and_grad_float(imfix, T, interp_type, out_type, out_val);
    elseif isa(imfix, 'double') && isa(T, 'double')
        [imdef, grad] = mex_2d_image_warp_and_grad_double(imfix, T, interp_type, out_type, out_val);
    else
        error('Variables class mismatch')
    end
end