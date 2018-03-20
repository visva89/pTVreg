function imm = imdeform(imfix, T, varargin) %, interp_type, out_type, out_val)
% deform image

    interp_type = 0;
    out_type = 0;
    out_val = 0;
    pix_resolution = [1,1,1];
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
            pix_resoultion = varargin{4};
            T = conv_3d_T_from_phys_to_pix(T, pix_resolution);
        end
    end
    
    nc = 1;
    if ndims(imfix) == 3 && size(imfix, 3) == 3
        d = 2;
        nc = 3;
    else
        d = ndims(imfix);
    end
    
    if d == 3
        if size(imfix, 1) ~= size(T, 1) || size(imfix, 2) ~= size(T, 2) ||...
                size(imfix, 3) ~= size(T, 3) || size(T, 4) ~= 3
            error('Dimensions dont match');
        end
    elseif d == 2
        if size(imfix, 1) ~= size(T, 1) || size(imfix, 2) ~= size(T, 2) ||...
             size(T, 3) ~= 2
            error('Dimensions dont match');
        end
    end
    
    if d == 3
        if isa(imfix, 'single') && isa(T, 'single')
            imm = mex_3d_volume_warp_float(imfix, T, interp_type, out_type, out_val);
        elseif isa(imfix, 'double') && isa(T, 'double')
            imm = mex_3d_volume_warp_double(imfix, T, interp_type, out_type, out_val);
        else
            error('Variables class mismatch')
        end
    elseif d == 2
        if isa(imfix, 'single') && isa(T, 'single')
            if nc == 3
                imm = imfix;
                for i = 1 : nc
                    imm(:,:,i) = mex_2d_image_warp_float(imfix(:,:,i), T, interp_type, out_type, out_val);
                end
            else
                imm = mex_2d_image_warp_float(imfix, T, interp_type, out_type, out_val);
            end
        elseif isa(imfix, 'double') && isa(T, 'double')
            if nc == 3
                imm = imfix;
                for i = 1 : nc
                    imm(:,:,i) = mex_2d_image_warp_double(imfix(:,:,i), T, interp_type, out_type, out_val);
                end
            else
                imm = mex_2d_image_warp_double(imfix, T, interp_type, out_type, out_val);
            end
        elseif isa(imfix, 'uint8') && isa(T, 'float')
            if nc == 3
                imm = imfix;
                for i = 1 : nc
                    imm(:,:,i) = mex_2d_image_warp_uint8(imfix(:,:,i), T, interp_type, out_type, out_val);
                end
            else
                imm = mex_2d_image_warp_uint8(imfix, T, interp_type, out_type, out_val);
            end
        else
            error('Variables class mismatch')
        end
    end
    
end