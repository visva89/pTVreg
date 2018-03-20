function D = ptv_disp_from_knots(Knots, volsz, grid_spacing, K_ord, Nd, varargin)
% Knots, volsz, grid_spacing, K_ord, Nd, {KT}
%     Nd = size(Knots, 4);
    ksz = [size(Knots, 1), size(Knots, 2), size(Knots, 3)];
    KT = [];
    if nargin >= 6
        KT = varargin{1};
    end
    if isempty(KT) && K_ord == 3.5
        KT = create_3d_image_upsample_matrix(ksz, volsz, 1);
    end
    Nimgs = size(Knots, 5);
    D = zeros([volsz, Nd, Nimgs]);
    for i = 1 : Nimgs
        if K_ord == 1
            if Nd == 2
                Dt = linear_disp_2d(squeeze(Knots(:,:, 1, :, i)), volsz, grid_spacing);
            elseif Nd == 3
                Dt = linear_disp_3d(squeeze(Knots(:,:, :, :, i)), volsz, grid_spacing);
            end
        elseif K_ord == 3
            if Nd == 2
                Dt = cubic_disp_2d(squeeze(Knots(:,:,1,:, i)), volsz, grid_spacing);
            elseif Nd == 3
                Dt = cubic_disp_3d(Knots(:,:,:,:, i), volsz, grid_spacing);
            end
        elseif K_ord == 3.5
            if Nd == 2
                Dt = cat(3, reshape(full(KT * fl(Knots(:,:,:, 1, i))), volsz), ...
                            reshape(full(KT * fl(Knots(:,:,:, 2, i))), volsz));
            elseif Nd == 3
                Dt = cat(4, reshape(full(KT * fl(Knots(:,:,:, 1, i))), volsz), ...
                            reshape(full(KT * fl(Knots(:,:,:, 2, i))), volsz), ...
                            reshape(full(KT * fl(Knots(:,:,:, 3, i))), volsz));
            end
        elseif K_ord == -1
            if Nd == 2
                Mat = ptv_params_to_matrix(Knots(:,:,:,:, i), 'translate');
                Dt = displ_from_matrix_2d(Mat, volsz, [], false);
                Dt = reshape(Dt, [volsz(1), volsz(2), 1, 2]);
            elseif Nd == 3
                
            end
        elseif K_ord == -2
            if Nd == 2
                Mat = ptv_params_to_matrix(Knots(:,:,:,:, i), 'rigid');
                Dt = displ_from_matrix_2d(Mat, volsz, [], false);
                Dt = reshape(Dt, [volsz(1), volsz(2), 1, 2]);
            elseif Nd == 3
            end
        elseif K_ord == -3
            if Nd == 2
                Mat = ptv_params_to_matrix(Knots(:,:,:,:, i), 'rigid_scale');
                Dt = displ_from_matrix_2d(Mat, volsz, [], false);
                Dt = reshape(Dt, [volsz(1), volsz(2), 1, 2]);
            elseif Nd == 3
            end
        elseif K_ord == -4
            if Nd == 2
                Mat = ptv_params_to_matrix(Knots(:,:,:,:, i), 'affine');
                Dt = displ_from_matrix_2d(Mat, volsz, [], false);
                Dt = reshape(Dt, [volsz(1), volsz(2), 1, 2]);
            elseif Nd == 3
            end
        else
            error('Wrong K_ord');
        end
        D(:,:,:, :, i) = Dt;
    end
%     tic
%     tmp = KT * fl(Knots(:,:,:, 1, i));
%     t1 = toc();
%     tic
%     tmp = full(KT * fl(Knots(:,:,:, 1, i)));
%     t2 = toc();
%     tic
%     tt = fl(Knots(:,:,:, 1, i));
%     tmp = full(KT * tt(:));
%     t3 =toc();
%     [t1, t2, t3, tt0/3]
    
%     issparse()
end