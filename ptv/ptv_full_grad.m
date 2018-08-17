
function [err, grad, fData, fReg] = ptv_full_grad(volmov, volfix, Knots, Knots_size, ...
            isoTV, D1L1, D1L2, D2L1, D2L2, ...
            regul_displs_directly, csqrt,...
            A1, A2, mean_penalty, ...
            T_D1L1, T_D1L2, T_D2L1, T_D2L2, DT1, DT2, D1Lp, spat_reg_p_val,...
            D2Lp, spat_reg_p_val2, ...
            grid_spacing, pix_resolution, interp_type, metric, ...
            nuclear_coef, singular_coefs, ...
            cur_fixed_mask, cur_moving_mask, cache,  ...
            internal_dtype, fold_k, K_ord, KT,...
            mov_segm, segm_val1, segm_val0, segm_koef, Nd, jac_reg, ...
            edge_prior, local_nuclear_patch_size, nuclear_centering)
    out_type = 0;
    out_val = 0;
    Knots = reshape(Knots, Knots_size);
    [volsz, ~, Nch, Nimgs] = ptv_get_sizes_from_volsz(size(volmov));
    if Nd == 2
        volsz = [volsz(1), volsz(2), 1];
    end
   
    % weighting
    if K_ord == -2 || K_ord == -3 || K_ord == -4
        weights = ptv_get_weighting(Knots, K_ord, Nd, pix_resolution(1:Nd), volsz(1:Nd));
        Knots = Knots .* weights;
    end
    
    err = 0;
    fData = 0;
    fReg = 0;
    
    grad = zeros(size(Knots), 'like', volmov);
    
    pix_vol = prod(pix_resolution);
    Knots = convert_to_dtype(Knots, internal_dtype);
%     Knots_pix = Knots;
    Knots_pix = ptv_params_phys_to_pix(Knots, pix_resolution(1:Nd), K_ord);

    [voldef, vol_grads] = ptv_disp_and_warp_and_grad(Knots_pix, volmov, grid_spacing, pix_resolution, interp_type, out_type, out_val, K_ord, KT, Nd);
%     imagesc(voldef(:,:,end)); pause(0.01);
%     imagesc(squeeze(mean(voldef(:,:, 1, :, :), 5))); pause(0.02);
    if strcmp(metric, 'nuclear')
        if Nimgs <= 1
            error('Groupwize registration is possible only if size(volmov, 5) >= 2');
        end
        gNuclear = zeros([volsz, Nch, Nimgs], 'like', voldef);
        for ic = 1 : Nch
            volfixtmp = [];
            if ~isempty(volfix)
                volfixtmp = squeeze(volfix(:,:,:, ic, :));
            end
            [err_N, nuc_G] = ptv_nuclear_metric(volfixtmp, voldef(:,:,:, ic, :), ...
                pix_resolution, cur_fixed_mask, singular_coefs, nuclear_centering);
            fData = fData + nuclear_coef * err_N / Nch;
            gNuclear(:,:,:, ic, :) = reshape(nuc_G, [volsz, 1, Nimgs]);
        end
        gG = sum(gNuclear .* vol_grads, 4) * (nuclear_coef / Nch);
    elseif strcmp(metric, 'local_nuclear')
        if Nimgs <= 1
            error('Groupwize registration is possible only if size(volmov, 5) >= 2');
        end
        gNuclear = zeros([volsz, Nch, Nimgs], 'like', voldef);
        for ic = 1 : Nch
            volfixtmp = [];
            if ~isempty(volfix)
                volfixtmp = squeeze(volfix(:,:,:, ic, :));
            end
            
%             subplot(121)
%             imagesc(voldef(:,:, round(end/2), 1, 1));
%                 subplot(122);
%                 imagesc( sum(Knots_pix(:,:, round(end/2), :, 1), 4)); colorbar;
%                 pause(0.02);
            nuclear_coef = 1;
            [err_N, nuc_G] = ptv_local_nuclear_metric(volfixtmp, voldef(:,:,:, ic, :), ...
                pix_resolution, cur_fixed_mask, singular_coefs, local_nuclear_patch_size, nuclear_centering);
            fData = fData + nuclear_coef * err_N / Nch;
            gNuclear(:,:,:, ic, :) = reshape(nuc_G, [volsz, 1, Nimgs]);
        end
        gG = sum(gNuclear .* vol_grads, 4) * (nuclear_coef / Nch);
    else
%         gG = zeros([volsz, 1, Nimgs, Nd], 'like', volmov);
        metGs = zeros([volsz, Nch, Nimgs], 'like', volmov);
        for ic = 1 : Nch
            em_opts = [];
            if ~isempty(cache)
                em_opts.cache = cache{ic};
            end
            for nn = 1 : Nimgs
                [err_IS, metG] = eval_metric(metric, squeeze(volfix(:, :, :, ic)), squeeze(voldef(:,:,:, ic, nn)), pix_resolution, em_opts, cur_fixed_mask);
                fData = fData + err_IS / (Nch * Nimgs);
                metGs(:, :, :, ic, nn) = metG;
            end
%             gG(:,:,:,:, nn, :) = gG(:,:,:,:, nn, :) + sum(metG .* vol_grads(:,:,:,:, nn, :), 4) / (Nch * Nimgs);
        end
        gG = sum(metGs .* vol_grads, 4) / (Nch * Nimgs);
        clear metG
        clear metGs
    end
    
%     size(gG)
%     size(metGs)
%     size(vol_grads)
%     subplot(141);
%     imagesc(gG(:,:,1));
%     subplot(142);
%     imagesc(metGs(:,:,1));
%     subplot(143);
%     imagesc(vol_grads(:,:,1));
%     subplot(144);
%     imagesc(voldef(:,:, 1));
%     Knots_pix(:)
%     pause;
    err = fData;
    clear vol_grads

    
    if regul_displs_directly
        Displs = ptv_disp_from_knots(squeeze(Knots), volsz, grid_spacing, K_ord, Nd, KT);
        if isoTV ~= 0 
            [f_isoTV, g_isoTV] = isotropic_tv_regularization(Displs, pix_resolution, [], 1, csqrt);
            fReg = fReg + isoTV * f_isoTV / Nimgs;
            gG = gG + isoTV / Nimgs * reshape(permute(g_isoTV, [1,2,3,5,4]), [size(g_isoTV, 1), size(g_isoTV, 2), size(g_isoTV, 3), 1, Nimgs, Nd]);
            clear g_isoTV
        end
        if D2L1 ~= 0
            [f_D2L1, g_D2L1] = DL1c_regularization(Displs, pix_resolution, A2, csqrt);
            fReg = fReg + D2L1 * f_D2L1 / Nimgs;
            gG = gG + D2L1 / Nimgs * reshape(permute(g_D2L1, [1,2,3,5,4]), [size(g_D2L1, 1), size(g_D2L1, 2), size(g_D2L1, 3), 1, Nimgs, Nd]);
            clear g_D2L1
        end
        if D1L1 ~= 0
            [f_D1L1, g_D1L1] = DL1_regularization(Displs, pix_resolution, A1);
            fReg = fReg + D1L1 * f_D1L1 / Nimgs;
            gG = gG + D1L1 / Nimgs * reshape(permute(g_D1L1, [1,2,3,5,4]), [size(g_D1L1, 1), size(g_D1L1, 2), size(g_D1L1, 3), 1, Nimgs, Nd]);
            clear g_D1L1
        end
        if D2L2 ~= 0
            [f_D2L2, g_D2L2] = DL2_regularization(Displs, pix_resolution, A2);
            fReg = fReg + D2L2 * f_D2L2 / Nimgs;
            gG = gG + D2L2 / Nimgs * reshape(permute(g_D2L2, [1,2,3,5,4]), [size(g_D2L2, 1), size(g_D2L2, 2), size(g_D2L2, 3), 1, Nimgs, Nd]);
            clear g_D2L2
        end
        if D1L2 ~= 0
            [f_D1L2, g_D1L2] = DL2_regularization(Displs, pix_resolution, A1);
            fReg = fReg + D1L2 * f_D1L2 / Nimgs;
            gG = gG + D1L2 / Nimgs * reshape(permute(g_D1L2, [1,2,3,5,4]), [size(g_D1L2, 1), size(g_D1L2, 2), size(g_D1L2, 3), 1, Nimgs, Nd]);
            clear g_D1L1
        end
        clear Displs
    else
        if isoTV ~= 0
            [f_isoTV, g_isoTV] = isotropic_tv_regularization(Knots, pix_resolution .* grid_spacing, [], 1, csqrt);
            fReg = fReg + isoTV / Nimgs * f_isoTV;
            grad = grad + isoTV / Nimgs * g_isoTV;
            clear g_isoTV
        end
        if D2L1 ~= 0
            [f_D2L1, g_D2L1] = DL1c_regularization(Knots, pix_resolution .* grid_spacing, A2, csqrt);
            fReg = fReg + D2L1 / Nimgs * f_D2L1;
            grad = grad + D2L1 / Nimgs * g_D2L1;
            clear g_D2L1
        end
        if D1L1 ~= 0
            [f_D1L1, g_D1L1] = DL1_regularization(Knots, pix_resolution .* grid_spacing, A1);
            fReg = fReg + D1L1 / Nimgs * f_D1L1;
            grad = grad + D1L1 / Nimgs * g_D1L1;
            clear g_D1L1
        end
        if D2L2 ~= 0
            [f_D2L2, g_D2L2] = DL2_regularization(Knots, pix_resolution .* grid_spacing, A2);
            fReg = fReg + D2L2 / Nimgs * f_D2L2;
            grad = grad + D2L2 / Nimgs * g_D2L2;
            clear g_D2L2
        end
        if D1L2 ~= 0
            [f_D1L2, g_D1L2] = DL2_regularization(Knots, pix_resolution .* grid_spacing, A1);
            fReg = fReg + D1L2 / Nimgs * f_D1L2;
            grad = grad + D1L2 / Nimgs * g_D1L2;
            clear g_D1L2
        end
    end
    if D1Lp > 0
        [f_D1Lp, g_D1Lp] = iso_spatial_D1Lp_regularization(Knots, pix_resolution .* grid_spacing, Nd, spat_reg_p_val, csqrt, edge_prior);
        fReg = fReg + f_D1Lp * (D1Lp / Nimgs);
        grad = grad + g_D1Lp * (D1Lp / Nimgs);
        clear g_D1Lp
    end
    if D2Lp > 0
        [f_D2Lp, g_D2Lp] = iso_spatial_D2Lp_regularization(Knots, pix_resolution .* grid_spacing, Nd, spat_reg_p_val, csqrt, edge_prior);
        fReg = fReg + f_D2Lp * (D2Lp / Nimgs);
        grad = grad + g_D2Lp * (D2Lp / Nimgs);
        clear g_D2Lp
    end
    if T_D1L1 > 0 
        [f_tD1L1, g_tD1L1] = temporal_DLp_regularization(Knots, pix_resolution .* grid_spacing, DT1, 1, csqrt);
        fReg = fReg + f_tD1L1 * T_D1L1 / Nimgs;
        grad = grad + g_tD1L1 * (T_D1L1 / Nimgs);
        clear g_tD1L1
    end
    if T_D2L1 >0 
        [f_tD2L1, g_tD2L1] = temporal_DLp_regularization(Knots, pix_resolution .* grid_spacing, DT2, 1, csqrt);
        fReg = fReg + f_tD2L1 * T_D2L1 / Nimgs;
        grad = grad + g_tD2L1 * (T_D2L1 / Nimgs);
        clear g_tD2L1
    end
    if T_D1L2 >0 
        [f_tD1L2, g_tD1L2] = temporal_DLp_regularization(Knots, pix_resolution .* grid_spacing, DT1, 2, csqrt);
        fReg = fReg + f_tD1L2 * T_D1L2 / Nimgs;
        grad = grad + g_tD1L2 * (T_D1L2 / Nimgs);
        clear g_tD1L2
    end
    if T_D2L2 >0 
        [f_tD2L2, g_tD2L2] = temporal_DLp_regularization(Knots, pix_resolution .* grid_spacing, DT2, 2, csqrt);
        fReg = fReg + f_tD2L2 * T_D2L2 / Nimgs;
        grad = grad + g_tD2L2 * (T_D2L2 / Nimgs);
        clear g_tD2L2
    end
    if mean_penalty > 0
        tmp = sum(Knots, 5);
        gvol = prod(pix_resolution .* grid_spacing);
        fReg = fReg + sum(tmp(:).^2) * (mean_penalty * gvol / 2 / Nimgs );
        grad = grad + repmat(tmp, [1,1,1,1,Nimgs]) * (mean_penalty * gvol / Nimgs );
    end
    
    if fold_k > 0
        [f_fold, g_fold] = folding_regularization(Knots, pix_resolution .* grid_spacing, 0.01);
        fReg = fReg + fold_k / Nimgs * f_fold;
        grad = grad + fold_k / Nimgs * g_fold;
    end
    if jac_reg > 0
        [f_jac, g_jac] = det_regularization_v1(Knots, pix_resolution .* grid_spacing, 0.2, 4);
        fReg = fReg + jac_reg / Nimgs * f_jac;
        grad = grad + jac_reg / Nimgs * g_jac;
    end
    
    % segmentation
    if ~isempty(mov_segm) && segm_koef > 0
        [segmdef, segm_grads] = ptv_disp_and_warp_and_grad(Knots_pix, mov_segm, grid_spacing, pix_resolution, interp_type, out_type, out_val, K_ord, KT);
        
        sdif1 = volfix - segmdef * segm_val1;
        sdif0 = volfix - (1-segmdef) * segm_val0;
        ssdif1 = -sign(sdif1);
        ssdif2 = sign(sdif0);
        
        fReg = fReg + segm_koef * pix_vol * (sum(abs(sdif1(:))) + sum(abs(sdif0(:))));
        gG = gG + segm_koef * pix_vol * ( (ssdif1 * segm_val1 + ssdif2 * segm_val0) .* segm_grads );
        clear segmdef
        clear segm_grads
    end
    err = err + fReg;
    if K_ord == -1 || K_ord == -2 || K_ord == -3 || K_ord == -4
        grad = grad + ptv_Jacob_matrix(gG, Knots_pix, K_ord, Nd, pix_resolution);
%         jac regularization
        for i = 1 : Nimgs
            facj = @(x) affine_jac_cost(x, K_ord, Nd, pix_resolution(1:Nd), volsz(1:Nd));
            acj_f0 = facj(Knots(:,:,:,:, i));
            acj_gn = numerical_grad(facj, Knots(:,:,:,:, i), 1e-6, []);
            alpha = 110.2 / Nimgs;
            err = err + alpha * acj_f0;
            grad(:, 1,1,1, i) = grad(:, 1,1,1, i) + alpha * acj_gn(:);
        end
    else
        ksz = Knots_size(1:3);
        grad = grad + ptv_partial_conv(gG, [ksz, Nd, Nimgs], grid_spacing, K_ord, KT);
    end
%     if K_ord == -3
%         err = err + numel(volmov)/1000 * sum(fl(Knots(4, :,:,:,:)).^ 2)/2;
%         grad(4,:,:,:,:) = grad(4,:,:,:,:) + numel(volmov)/1000 * Knots(4,:,:,:,:);
%     end
%     fprintf('Fdata=%e   Freg=%e\n', fData, fReg);
    if K_ord == -2 || K_ord == -3 || K_ord == -4
        grad = grad .* weights;
    end
    
    err = convert_to_dtype(err, 'CPU_double');
    grad = convert_to_dtype(grad(:), 'CPU_double');
end

function weights = ptv_get_weighting(Knots, K_ord, Nd, pix_resolution, volsz)
    weights = ones(size(Knots));    
%     if K_ord == -2 || K_ord == -3 || K_ord == -4
%         qn = max(pix_resolution .* volsz) / 4;
%         weights(Nd+1:end, :,:,:, :) = weights(Nd+1:end, :,:,:, :) / qn;
%     end
end

function err = affine_jac_cost(params, K_ord, Nd, pix_resolution, volsz)
    M = ptv_params_to_matrix(params, K_ord);
    M1 = M(1:Nd, 1:Nd);
    trans = M(1:Nd, end);
    d = det(M1);
    orth = sum(sum((M1'*M1 - eye(Nd)).^2))*2;
%     d
%     pause
%     max(volsz(:)/4, abs(trans(:)./pix_resolution))
    err = 0;
    err = max(0.02, (d-1)^2);
    err = err + max(0.02, orth)*2;
    err = err + sum(max(volsz(:)/4, abs(trans(:)./pix_resolution(:))));
%     if abs(d-1) > 0.5
%         err = err + 1e+10;
%     end
end

function grad = ptv_Jacob_matrix(gG, Knots, K_ord, Nd,pix_resolution)
    Nimgs = size(gG, 5);
    grad = zeros(size(Knots), 'like', gG);
    if Nd == 2
        [m1, m2] = ndgrid(1:size(gG, 1), 1:size(gG, 2));
        m1 = m1 - size(m1,1)/2;
        m2 = m2 - size(m1,2)/2;
    end
    for i = 1 : Nimgs
        if K_ord == -1
            grad(1, 1,1,1, i) = sum(fl( gG(:,:, 1, 1, i, 1)));
            grad(2, 1,1,1, i) = sum(fl( gG(:,:, 1, 1, i, 2)));
        elseif K_ord == -2
            theta = Knots(3, 1,1,1, i);
            J1 = -m1 * (sin(theta)) - m2 * cos(theta);
            J2 =  m1 * cos(theta) - m2 * (sin(theta));
            grad(3, 1,1,1, i) = sum(fl( gG(:,:, 1, 1, i, 1) .* J1*pix_resolution(1) + gG(:,:, 1, 1, i, 2) .* J2*pix_resolution(2)));
            grad(1, 1,1,1, i) = sum(fl( gG(:,:, 1, 1, i, 1)));
            grad(2, 1,1,1, i) = sum(fl( gG(:,:, 1, 1, i, 2)));
        elseif K_ord == -3
            theta = Knots(3, 1,1,1, i);
            sc = Knots(4, 1,1,1, i);
            J1 = -m1 * (sin(theta))*(1+sc) - m2 * cos(theta)*(1+sc);
            J2 =  m1 * cos(theta)*(1+sc) - m2 * (sin(theta))*(1+sc);
            
            Js1 = m1 * cos(theta) - m2 * sin(theta);
            Js2 = m1 * sin(theta) + m2 * cos(theta);
            grad(4, 1,1,1, i) = sum(fl( gG(:,:, 1, 1, i, 1) .* Js1*pix_resolution(1) + gG(:,:, 1, 1, i, 2) .* Js2*pix_resolution(2)));
            grad(3, 1,1,1, i) = sum(fl( gG(:,:, 1, 1, i, 1) .* J1*pix_resolution(1) + gG(:,:, 1, 1, i, 2) .* J2*pix_resolution(2)));
            grad(1, 1,1,1, i) = sum(fl( gG(:,:, 1, 1, i, 1)));
            grad(2, 1,1,1, i) = sum(fl( gG(:,:, 1, 1, i, 2)));
        elseif K_ord == -4
            grad(3, 1,1,1, i) = sum(sum(gG(:,:, 1, 1, i, 1) .* m1)) * pix_resolution(1);
            grad(4, 1,1,1, i) = sum(sum(gG(:,:, 1, 1, i, 1) .* m2)) * pix_resolution(1);
            grad(5, 1,1,1, i) = sum(sum(gG(:,:, 1, 1, i, 2) .* m1)) * pix_resolution(2);
            grad(6, 1,1,1, i) = sum(sum(gG(:,:, 1, 1, i, 2) .* m2)) * pix_resolution(2);
            grad(1, 1,1,1, i) = sum(sum(gG(:,:, 1, 1, i, 1)));
            grad(2, 1,1,1, i) = sum(sum(gG(:,:, 1, 1, i, 2)));
        end
    end
end


function grad = ptv_partial_conv(gG, ksz, grid_spacing, K_ord, KT)
    Nimgs = size(gG, 5);
    Nd = ksz(4);
    if K_ord == 1 && Nd == 3 && isa(gG, 'double')
        grad = mex_Nd_linear_partial_conv_double(gG, ksz, grid_spacing, 3);
        return;
    end
    
    grad = zeros(ksz, 'like', gG);
    for i = 1 : Nimgs
        switch K_ord
            case 1
                if Nd == 2
                    [gr1, gr2] = linear_partial_conv_2d(gG(:,:, 1, 1, i, 1), gG(:,:, 1, 1, i, 2), ksz, grid_spacing(1:2));
                else
                    [gr1, gr2, gr3] = linear_partial_conv_3d(gG(:,:,:, 1, i, 1), gG(:,:,:, 1, i, 2), gG(:,:,:, 1, i, 3), ksz, grid_spacing);
                end
            case 3.5
                if Nd == 2
                    gr1 = reshape(KT'*fl(gG(:,:, 1,1, i, 1)), ksz(1:2));
                    gr2 = reshape(KT'*fl(gG(:,:, 1,1, i, 2)), ksz(1:2));
                else
                    gr1 = reshape(KT'*fl(gG(:,:,:, 1, i, 1)), ksz(1:3));
                    gr2 = reshape(KT'*fl(gG(:,:,:, 1, i, 2)), ksz(1:3));
                    gr3 = reshape(KT'*fl(gG(:,:,:, 1, i, 3)), ksz(1:3));
                end
            case 3
                if Nd == 3
                    [gr1, gr2, gr3] = cubic_partial_conv_3d(gG(:,:,:, 1, i, 1), gG(:,:,:, 1, i, 2), gG(:,:,:, 1, i, 3), ksz, grid_spacing);
                elseif Nd == 2
                    [gr1, gr2] = cubic_partial_conv_2d(gG(:,:,1, 1, i, 1), gG(:,:,1, 1, i, 2), ksz, grid_spacing);
                end
        end
        if Nd == 2
            grad(:,:, 1, 1, i) = gr1;
            grad(:,:, 1, 2, i) = gr2;
        else
            grad(:,:, :, 1, i) = gr1;
            grad(:,:, :, 2, i) = gr2;
            grad(:,:, :, 3, i) = gr3;
        end
    end
%     max(fl(abs(grad-grad2)))
end


function [voldef, vol_grads] = ptv_disp_and_warp_and_grad(Knots_pix, volmov, grid_spacing, pix_resolution, interp_type, out_type, out_val, K_ord, KT, Nd)
% linear grid with linear interpolation has its own fast function. Other
% stuff is handled manually
    if K_ord == 1  && isa(volmov, 'double') 
        [voldef, vol_grads] = mex_Nd_linear_disp_and_warp_and_grad_double(Knots_pix, volmov, grid_spacing, pix_resolution, interp_type, out_type, out_val);
        return;
    end
    [volsz, ~, Nch, Nimgs] = ptv_get_sizes_from_volsz(size(volmov));
%     Nd = size(Knots_pix, 4);
    voldef = zeros(size(volmov), 'like', volmov);
    if numel(volsz) == 2
        volsz = [volsz(1), volsz(2), 1];
    end
    vol_grads = zeros([volsz, Nch, Nimgs, Nd], 'like', volmov);
    
    manual_mode = true;
    if K_ord == 1 && interp_type == 0    %K_ord == 3 || K_ord == 3.5 || K_ord < 0 || interp_type == 1
        manual_mode = false;
    end
    
    for i = 1 : Nimgs
        if manual_mode
            Tpix = ptv_disp_from_knots(Knots_pix(:,:,:,:, i), volsz, grid_spacing, K_ord, Nd, KT);
        end
        for j = 1 : Nch
            if ~manual_mode
                if Nd == 2
                    [vt, g1, g2] = linear_disp_and_warp_and_grad_2d(squeeze(Knots_pix(:,:,1, :, i)), ...
                            squeeze(volmov(:,:, 1, j,i)), grid_spacing, pix_resolution(1:Nd), interp_type, out_type, out_val);    
                elseif Nd == 3
                    [vt, g1, g2, g3] = linear_disp_and_warp_and_grad_3d(Knots_pix(:,:,:,:, i), ...
                            volmov(:,:,:, j, i), grid_spacing, pix_resolution, interp_type, out_type, out_val);
                end
            else %if K_ord == 3 || K_ord == 3.5 || K_ord == -1 || K_ord == -2 || K_ord == -3 || K_ord == -4
%                 vt = ptv_deform(volmov(:,:,:, j, i), Tpix, interp_type, out_type, out_val);
                switch Nd
                    case 2
%                         [g1, g2] = my_gradient(squeeze(vt), pix_resolution(1:Nd), 0, 2);
%                         [g1,g2] = warp_gradient(squeeze(volmov(:,:,:, j, i)), squeeze(Tpix), pix_resolution(1:Nd), interp_type, out_type);
                        [vt, G] = imdeform2_and_grad(squeeze(volmov(:,:,:, j, i)), squeeze(Tpix), interp_type);
                        g1 = G(:,:,1) / pix_resolution(1);
                        g2 = G(:,:,2) / pix_resolution(2);
                    case 3
%                         [g1, g2, g3] = my_gradient(vt, pix_resolution, 0, 2);
                        [vt, G] = imdeform3_and_grad(squeeze(volmov(:,:,:, j, i)), squeeze(Tpix), interp_type);
                        g1 = G(:,:,:,1) / pix_resolution(1);
                        g2 = G(:,:,:,2) / pix_resolution(2);
                        g3 = G(:,:,:,3) / pix_resolution(3);
                        
%                         subplot(141);
%                         imagesc(vt(:,:, round(end/2)));
%                         subplot(142);
%                         imagesc(G(:,:, round(end/2), 1));
%                         subplot(143);
%                         imagesc(G(:,:, round(end/2), 2));
%                         subplot(144);
%                         imagesc(G(:,:, round(end/2), 3));
%                         pause;
                end
            end
%             elseif K_ord == 3
%                 error('Obsolete');
%                 if Nd == 3
%                     [vt, g1, g2, g3] = cubic_disp_and_warp_and_grad_3d(Knots_pix(:,:,:,:, i), ...
%                             volmov(:,:,:, j, i), grid_spacing, pix_resolution, interp_type, out_type, out_val);
%                 end
%             end
            voldef(:,:,:, j, i) = vt;
            switch Nd
                case 2
                    vol_grads(:,:, 1, j, i, 1) = g1;
                    vol_grads(:,:, 1, j, i, 2) = g2;
                case 3
                    vol_grads(:,:,:,  j, i, 1) = g1;
                    vol_grads(:,:,:,  j, i, 2) = g2;
                    vol_grads(:,:,:,  j, i, 3) = g3;
            end
        end
    end
end



