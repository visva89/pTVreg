function voldef = ptv_deform(vols, D, varargin)
    % vols, D, {interp_type, out_type, out_val, pix_resolution}
    interp_type = 0;
    out_type = 0;
    out_val = 0;
    pix_resolution = [];
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
        end
    end
    
    voldef = zeros(size(vols), 'like', vols);
    if size(D, 4) == 2
        for i = 1 : size(vols, 5)
            voldef_i = imdeform2(squeeze(vols(:,:, 1, :, i)), squeeze(D(:,:,1, :, i)), interp_type, out_type, out_val, pix_resolution);
            voldef(:,:, 1, :, i) = reshape(voldef_i, size(voldef(:,:, 1, :, i)));
        end
    elseif size(D, 4) == 3
        for i = 1 : size(vols, 5)
            voldef_i = imdeform3(squeeze(vols(:,:, :, :, i)), squeeze(D(:, :, :, :, i)), interp_type, out_type, out_val, pix_resolution);
            voldef(:, :, :, :, i) = reshape(voldef_i, size(voldef(:,:, :, :, i)));
        end
    end
end