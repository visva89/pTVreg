function [Knots_n] = refine_linear_grid_3d(Knots, old_spacing, ds, volsz, varargin)
    %[Knots_n] = refine_linear_grid_3d(Knots, old_spacing, ds, volsz,
    %  {k_up, upsampling_type, old_size, new_spacing}
    k_down = 0.5;
    if nargin >= 5
        k_down = varargin{1};
    end
    upsampling_type = 'sample_std';
    if nargin >= 6
        upsampling_type = varargin{2};
    end
    new_spacing = old_spacing;
    if nargin >= 8
        new_spacing = varargin{4};
    end
    
    if false %k_down == 0.5
        Knots_sz = ceil(volsz ./ old_spacing) + 1;
        Knots_n = linear_disp_3d(Knots, Knots_sz, ds+1);
    else
        interp_type = 0;
        tmp = size(Knots);
        ksz2 = (fl(tmp(1:3)) .* (ds(:) + 1))';
        ksz2 = ceil(volsz ./ new_spacing) + 1;
    %     ksz2 = size(Knots_n); ksz2 = ksz2(1:3);
    
%         tmp = cat(4, volresize(Knots(:,:,:,1), ksz2, interp_type, upsampling_type), ...
%                      volresize(Knots(:,:,:,2), ksz2, interp_type, upsampling_type), ...
%                      volresize(Knots(:,:,:,3), ksz2, interp_type, upsampling_type));
        %Knots_n = tmp;
        
        Kt = zeros([ksz2, 3]);
        ksz3 = round([size(Knots,1),size(Knots,2),size(Knots,3)] ./ k_down);
        ksz3 = ksz3(1:3);
        tmp = cat(4, volresize_t2(Knots(:,:,:,1), 1./k_down, interp_type), ...
                     volresize_t2(Knots(:,:,:,2), 1./k_down, interp_type), ...
                     volresize_t2(Knots(:,:,:,3), 1./k_down, interp_type));
        Kt(1:size(tmp,1), 1:size(tmp,2), 1:size(tmp,3), :) = tmp;
        Kt = Kt(1:ksz2(1), 1:ksz2(2), 1:ksz2(3), :);
        Knots_n = Kt;
%         ksz2
%         ksz3
%         size(Knots_n)
%         pause;
    %     Knots_n = tmp(1:ksz1(1), 1:ksz1(2), 1:ks z1(3), :);
    end
    if strcmp(upsampling_type, 'variation')
        old_volsz = varargin{2};
        new_spacing = varargin{3};
        
        Tmin = linear_disp_3d(Knots, old_volsz, old_spacing);
        Tmin_u = cat(4, volresize(Tmin(:,:,:, 1),volsz, 0), volresize(Tmin(:,:,:, 2), volsz, 0), volresize(Tmin(:,:,:, 3), volsz, 0));
                    
        objf = @(x) align_knots(x, Tmin_u, volsz, size(Knots_n), new_spacing);
        uopt = []; uopt.method = 'lbfgs'; uopt.MaxIter = 30; uopt.Corr=15; uopt.Display = 'off';
        K2 = minFunc(objf, Knots_n(:), uopt);
        Knots2 = reshape(K2, size(Knots_n));
        Knots_n = Knots2;
    end
    
%     imagesc([ Knots_n2(:,:, 1), Knots_n(:,:, 1)]); pause;
%     Knots_n = Knots_n * 0.9 + Knots_n2 * 0.1;
%     Knots_n = Knots_n2;
%     Knots_n = cat(4, volresize(Knots(:,:,:,1), Knots_sz, 0), ...
%         volresize(Knots(:,:,:,2), Knots_sz, 0), volresize(Knots(:,:,:,3), Knots_sz, 0));
%     Knots_n = mex_3d_linear_disp_double(Knots, Knots_sz, ds+1);
    
    
%     for i = 1 : 3
%         if all( fl(Knots_n(:,:,end, i)) == 0)
%             Knots_n(:,:,end,i) = Knots_n(:,:,end-1,i);
%         end
%     end
%     for i = 1 : 3
%         if all( fl(Knots_n(:,end,:, i)) == 0)
%             Knots_n(:,end,:,i) = Knots_n(:,end-1,:,i);
%         end
%     end
%     for i = 1 : 3
%         if all( fl(Knots_n(end,:,:, i)) == 0)
%             Knots_n(end,:,:,i) = Knots_n(end-1,:,:,i);
%         end
%     end
   
    
%     T = mex3d_linear_disp(Knots, volsz, old_spacing);
%     ksz = ceil(volsz ./ new_spacing) + 1;
% %     1+new_spacing(1):new_spacing(1):(ksz(1)-1)*new_spacing(1)
%     m1 = min((ksz(1)-1)*new_spacing(1), volsz(1));
%     m2 = min((ksz(2)-1)*new_spacing(2), volsz(2));
%     m3 = min((ksz(3)-1)*new_spacing(3), volsz(3));
%     Knots_n =...
%         T([1, round(1+new_spacing(1):new_spacing(1):m1), volsz(1)], ...
%           [1, round(1+new_spacing(2):new_spacing(2):m2), volsz(2)], ...
%           [1, round(1+new_spacing(3):new_spacing(3):m3), volsz(3)], :);

end

function [f, gr] = align_knots(K, T, szv, szk, grid_spacing)
    K = reshape(K, szk);
    Kx = linear_disp_3d(K, szv, grid_spacing);
    df = Kx - T;
    f = sum(df(:).^2)/2;
    [gr1, gr2, gr3] = linear_partial_conv_3d(df(:,:,:, 1), df(:,:,:, 2), df(:,:,:, 3), ...
                     size(K), grid_spacing); 
    gr = [gr1(:); gr2(:); gr3(:)];
end
