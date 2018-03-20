function [imgs, ds, pix_resolutions] = ptv_create_pyramid(img, nlevels, pix_resolution, varargin)
%    create_iso_pyramid(img, nlevels, pix_resolution, varargin, {force_isotropic, k_down, interp_type, fine_rescale})
%
    if isempty(img)
        imgs = [];
        ds = [];
        pix_resolutions = [];
        return;
    end
    interp_type = 0;
    force_isotropic = false;
    if nargin >= 4
        force_isotropic = varargin{1};
    end
    if force_isotropic
        error('not implemented');
    end
    k_down = 0.5;
    if nargin >= 5
        k_down = varargin{2};
    end
    if nargin >= 6
        interp_type = varargin{3};
    end
    fine_rescale = false;
    if nargin >= 7
        fine_rescale = varargin{4};
    end
    
    ndims = 2;
    if size(img, 3) > 1
        ndims = 3;
    end
        
    Nch = size(img, 4);
    Nimgs = size(img, 5);
    pix_resolutions = zeros(nlevels, 3);

    pix_resolutions(1, :) = pix_resolution;
    imgs = cell(nlevels, 1);
    imgs{1} = img;
    ds = ones(nlevels, ndims);
    for i = 2 : nlevels
        if ~force_isotropic
            d = ones(1, ndims);
        end
        
        idxs = cell(ndims, 1);
        newsz = zeros(ndims, 1);
        if fine_rescale
            sigmas = 0.5 * ones(ndims, 1) * (0.5/k_down * (i-1));
        else
            sigmas = 0.4 * ones(ndims, 1) * (0.5/k_down);
        end
        
        newsz = ceil(k_down * size(imgs{i-1}(:,:,:, 1)));
        if ndims == 3
            imgs{i} = zeros([newsz, Nch, Nimgs]);
        elseif ndims == 2
            imgs{i} = zeros([newsz, 1, Nch, Nimgs]);
        end
        pix_resolutions(i, :) = pix_resolutions(i - 1, :) / k_down;
        
        for jj = 1 : Nch
            for ii = 1 : Nimgs
                if ndims == 2
                    if fine_rescale
                        t = imgaussfilt(imgs{1}(:,:, 1, jj, ii), sigmas);
                    else
                        t = imgaussfilt(imgs{i-1}(:,:, 1, jj, ii), sigmas);
                    end
                    imgs{i}(:,:, :, jj, ii) = imresize(t, size(imgs{i}(:,:, 1, jj, ii)), 'bilinear');
                elseif ndims == 3
                    if fine_rescale
                        t = imgaussfilt3(imgs{1}(:,:,:, jj, ii), sigmas);
                    else
                        t = imgaussfilt3(imgs{i-1}(:,:,:, jj, ii), sigmas);
                    end
                    imgs{i}(:,:,:, jj, ii) = volresize(t, size(imgs{i}(:,:,:, jj, ii)), interp_type);
                end
            end
        end
    end
end