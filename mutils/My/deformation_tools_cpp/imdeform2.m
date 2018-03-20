function imm = imdeform2(imfix, T, varargin) %, interp_type, out_type, out_val, pix_resolution)
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
    d = 2;
    nc = size(imfix, 3);
    
    if size(imfix, 1) ~= size(T, 1) || size(imfix, 2) ~= size(T, 2) || size(T, 3) ~= 2
        size(imfix)
        size(T)
        error('Dimensions dont match');
    end
    
    if isa(imfix, 'single') && isa(T, 'single')
        imm = zeros(size(imfix), 'single');
        for i = 1 : nc
            imm(:,:, i) = mex_2d_image_warp_float(imfix(:,:, i), T, interp_type, out_type, out_val);
        end
    elseif isa(imfix, 'double') && isa(T, 'double')
        imm = zeros(size(imfix), 'double');
        for i = 1 : nc
            imm(:,:, i) = mex_2d_image_warp_double(imfix(:,:, i), T, interp_type, out_type, out_val);
        end
    else
        error('Variables class mismatch')
    end
end