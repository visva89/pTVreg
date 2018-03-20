function imm = imdeform3(imfix, T, varargin) %, interp_type, out_type, out_val, pix_resolution)
% deform image
    interp_type = 0;
    out_type = 0;
    out_val = 0;
    pix_resolution = [1,1,1];
    
    if ~strcmp(class(imfix), class(T))
        error('im ~= T class');
    end
    
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
            T = conv_3d_T_from_phys_to_pix(T, pix_resolution);
        end
    end
    d = 3;
    nc = size(imfix, 4);
    
    if size(imfix, 1) ~= size(T, 1) || size(imfix, 2) ~= size(T, 2) ||...
            size(imfix, 3) ~= size(T, 3) || size(T, 4) ~= 3
        error('Dimensions dont match');
    end
    
    
    if isa(imfix, 'single') && isa(T, 'single')
        imm = zeros(size(imfix), 'single');
        for i = 1 : nc
            imm(:,:,:, i) = mex_3d_volume_warp_float(imfix(:,:,:, i), T, single(interp_type), single(out_type), single(out_val));
        end
    elseif isa(imfix, 'double') && isa(T, 'double')
        imm = zeros(size(imfix), 'double');
        for i = 1 : nc
            imm(:,:,:, i) = mex_3d_volume_warp_double(imfix(:,:,:, i), T, interp_type, out_type, out_val);
        end
    elseif isa(imfix, 'gpuArray') && isa(T, 'gpuArray')
        if strcmp(classUnderlying(imfix), 'single') && strcmp(classUnderlying(T), 'single')
            imm = zeros(size(imfix), 'single', 'gpuArray');
            for i = 1 : nc
                imm(:,:,:, i) = mex_3d_volume_warp_GPU_float(imfix(:,:,:, i), T, single(interp_type), single(out_type), single(out_val));
            end
        end
    else
        error('Variables class mismatch')
    end
end