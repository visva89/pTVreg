function Tcomp = compose_displ(T1, T2, varargin) %, interp_type, out_type, out_val, pix_resolution)
% compose_displ(T1, T2, interp_type, out   
% equiv im_0 = imdeform2(im, compose_displ(squeeze(T1), squeeze(T2), 1), 1);
    interp_type = 0;
    out_type = 0;
    out_val = 0;
    pix_resolution = ones(ndims(T1)-1, 1);
    
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
            if ndims(T1) == 3
                T1 = conv_2d_T_from_phys_to_pix(T1, pix_resolution);
                T2 = conv_2d_T_from_phys_to_pix(T2, pix_resolution);
            elseif ndims(T1) == 4
                T1 = conv_3d_T_from_phys_to_pix(T1, pix_resolution);
                T2 = conv_3d_T_from_phys_to_pix(T2, pix_resolution);
            end
        end
    end
    
    if ndims(T1) == 3
        T2pix = T2;
        if any(pix_resolution(:) ~= [1;1])
            T2pix = conv_2d_T_from_phys_to_pix(T2, pix_resolution);
        end
        tc1 = imdeform(T1(:,:,1), T2pix, interp_type, out_type, out_val);
        tc2 = imdeform(T1(:,:,2), T2pix, interp_type, out_type, out_val);
        Tcomp = cat(3, tc1 + T2(:, :, 1), tc2 + T2(:, :, 2));
        Tcomp = conv_2d_T_from_phys_to_pix(Tcomp, 1./pix_resolution);
    elseif ndims(T1) == 4
        tc1 = imdeform(T1(:,:,:,1), T2, 1);
        tc2 = imdeform(T1(:,:,:,2), T2, 1);
        tc3 = imdeform(T1(:,:,:,3), T2, 1);
        Tcomp = cat(4, tc1 + T2(:, :, :, 1), tc2 + T2(:, :, :, 2), tc3 + T2(:, :, :, 3));
        Tcomp = conv_3d_T_from_phys_to_pix(Tcomp, 1./pix_resolution);
    end
end