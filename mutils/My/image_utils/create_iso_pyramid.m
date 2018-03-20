function [imgs, ds, pix_resolutions] = create_iso_pyramid(img, nlevels, pix_resolution, varargin)
%    create_iso_pyramid(img, nlevels, pix_resolution, varargin, {force_isotropic, k_down, interp_type})
%
    interp_type = 0;
    
    force_isotropic = false;
    if nargin >= 4
        force_isotropic = varargin{1};
    end
    k_down = 0.5;
    if nargin >= 5
        k_down = varargin{2};
    end
    if nargin >= 6
        interp_type = varargin{3};
    end
    
    ndims = numel(pix_resolution);
    if ndims == 2
        Nch = size(img, 3);
    elseif ndims == 3
        Nch = size(img, 4);
    end
    pix_resolutions = zeros(nlevels, ndims);

    pix_resolutions(1, :) = pix_resolution;
    imgs = cell(nlevels, 1);
    imgs{1} = img;
    ds = ones(nlevels, ndims);
    for i = 2 : nlevels
        if force_isotropic
            d = zeros(1, ndims);
        else
            d = ones(1, ndims);
        end
        ms = max(pix_resolutions(i-1, :));
        for j = 1 : ndims
            if ms / pix_resolutions(i-1, j) > 1.4
                d(j) = 1;
            end
        end
        if nnz(d) == 0, d = ones(1, ndims); end
        
        ds(i, :) = d;
        
        idxs = cell(ndims, 1);
        newsz = zeros(ndims, 1);
        sigmas = 0.7 * ones(ndims, 1) * (0.5/k_down);
%         sigmas = 1.3 * ones(ndims, 1);
        for j = 1 : ndims
            if d(j) == 1
%                 pix_resolutions(i, j) = pix_resolutions(i - 1, j) * 2;
                pix_resolutions(i, j) = pix_resolutions(i - 1, j) / k_down;
                idxs{j} = 1 : 2 : size(imgs{i-1}, j);
                newsz(j) = round(size(imgs{i-1},j) * k_down);
            else
                idxs{j} = 1 : size(imgs{i-1}, j);
                newsz(j) = size(imgs{i-1},j);
                pix_resolutions(i, j) = pix_resolutions(i - 1, j);
                sigmas(j) = 0.0000001;
            end
        end
        
        if ndims == 2
%             imgs{i} = zeros([numel(idxs{1}), numel(idxs{2}), Nch]);
            imgs{i} = zeros([newsz', Nch]);
        elseif ndims == 3
%             imgs{i} = zeros([numel(idxs{1}), numel(idxs{2}), numel(idxs{3}), Nch]);
            imgs{i} = zeros([newsz', Nch]);
        end
        
        for jj = 1 : Nch
            if ndims == 2
                t = imgaussfilt(imgs{i-1}(:,:, jj), sigmas);
%                 imgs{i}(:,:, jj) = image_resize(t, 1 - d/2);
                imgs{i}(:,:, jj) = imresize(t, size(imgs{i}(:,:, jj)), 'bilinear');
%                 imgs{i}(:,:, jj) = t(idxs{1}, idxs{2});
            elseif ndims == 3
                t = imgaussfilt3(imgs{i-1}(:,:,:, jj), sigmas);
%                 imgs{i}(:,:,:, jj) = image_resize(t, 1 - d/2);
                imgs{i}(:,:,:, jj) = volresize(t, size(imgs{i}(:,:,:, jj)), interp_type);
%                 imgs{i}(:,:,:, jj) = t(idxs{1}, idxs{2}, idxs{3});
            end
        end
    end
end