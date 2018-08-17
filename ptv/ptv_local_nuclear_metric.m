function [err_N, sG] = ptv_local_nuclear_metric(volfix, voldef, pix_resolution, mask, singular_coefs, P_SZ, norm_type)
%% todo:
% * volfix
% * zero mean, choose std???
% * making zero mean changes gradient!

%     norm_type = 3;
    abs_type = 0;
    deps = 1e-3;
    
    volsz = [size(voldef, 1), size(voldef, 2), size(voldef, 3)];
    Nd = 3;
    if volsz(3) == 1
        Nd = 2;
    end
    
    P_SZ = round(P_SZ);
    Nimgs = size(voldef, 5);
    if Nd == 2
        P_SZ = [P_SZ, 1];
    end
 
    err_N = 0;
    sG = zeros([volsz, Nimgs], 'like', voldef);
    if Nd == 2
        for i1 = 1 : P_SZ(1) : volsz(1)
        for i2 = 1 : P_SZ(2) : volsz(2)
            i11 = min(i1 + P_SZ(1) - 1, volsz(1));
            i22 = min(i2 + P_SZ(2) - 1, volsz(2));
            if i11-i1 < 2 || i22 - i2 < 2
                continue;
            end
            patch = voldef(i1:i11, i2:i22, 1, :, :);
            if norm_type == 1
                patch = patch - sum(sum(sum(patch,1),2),3) / (size(patch,1)*size(patch,2)*size(patch,3));
            elseif norm_type == 2
                patch = patch - mean(patch(:));
            elseif norm_type == 3
                patch = patch - sum(sum( patch, 4), 5) / (size(patch,4)*size(patch,5));
            elseif norm_type == 4
                patch = patch - sum(sum(sum(patch,1),2),3) / (size(patch,1)*size(patch,2)*size(patch,3));
                patch = patch - sum(sum( patch, 4), 5) / (size(patch,4)*size(patch,5));
            end
            
            patch0 = reshape(patch, [size(patch, 1), size(patch, 2), size(patch, 3), Nimgs]);
            if abs_type == 1
                patch = abs(patch);
            elseif abs_type == 2
                patch = sqrt(patch.^2 + deps);
            end
            
            if ~isempty(mask)
                mask_cur = logical(mask(i1:i11, i2:i22));
            else
                mask_cur = [];
            end
            if isempty(mask_cur) || any(mask_cur(:))
                [terr, tgrad] = ptv_nuclear_metric([], patch, pix_resolution, mask_cur, singular_coefs);
                err_N = err_N + terr;
                
                if abs_type == 1
                    tgrad = tgrad.*sign(patch0);
                elseif abs_type == 2
                    tgrad = tgrad .* patch0 ./ sqrt(patch0.^2 + deps);
                end
                
                if norm_type == 1
                    tgrad = tgrad - sum(sum(sum(tgrad, 1), 2), 3) / (size(patch,1)*size(patch,2)*size(patch,3));
                elseif norm_type == 2
                    tgrad = tgrad - mean(tgrad(:));
                elseif norm_type == 3
                    tgrad = tgrad - sum(sum( tgrad, 4), 5) / (size(patch,4)*size(patch,5));
                elseif norm_type == 4
                    tgrad = tgrad - sum(sum( tgrad, 4), 5) / (size(patch,4)*size(patch,5));
                    tgrad = tgrad - sum(sum(sum(tgrad, 1), 2), 3) / (size(patch,1)*size(patch,2)*size(patch,3));
                end
                
                sG(i1:i11, i2:i22, 1, :) = tgrad;
            end
        end
        end
    else %3d
        for i1 = 1 : P_SZ(1) : volsz(1)
        for i2 = 1 : P_SZ(2) : volsz(2)
        for i3 = 1 : P_SZ(3) : volsz(3)
            i11 = min(i1 + P_SZ(1) - 1, volsz(1));
            i22 = min(i2 + P_SZ(2) - 1, volsz(2));
            i33 = min(i3 + P_SZ(3) - 1, volsz(3));
            if i11-i1 < 2 || i22 - i2 < 2 || i33 - i3 < 2
                continue;
            end
            patch = voldef(i1:i11, i2:i22, i3:i33, :, :);
            if norm_type == 1
                patch = patch - sum(sum(sum(patch,1),2),3) / (size(patch,1)*size(patch,2)*size(patch,3));
            elseif norm_type == 2
                patch = patch - mean(patch(:));
            elseif norm_type == 3
                patch = patch - sum(sum( patch, 4), 5) / (size(patch,4)*size(patch,5));
            elseif norm_type == 4
                patch = patch - sum(sum(sum(patch,1),2),3) / (size(patch,1)*size(patch,2)*size(patch,3));
                patch = patch - sum(sum( patch, 4), 5) / (size(patch,4)*size(patch,5));
            end
            
            patch0 = reshape(patch, [size(patch, 1), size(patch, 2), size(patch, 3), Nimgs]);
            if abs_type == 1
                patch = abs(patch);
            elseif abs_type == 2
                patch = sqrt(patch.^2 + deps);
            end
            
            if ~isempty(mask)
                mask_cur = logical(mask(i1:i11, i2:i22, i3:i33));
            else
                mask_cur = [];
            end
            if isempty(mask_cur) || any(mask_cur(:))
                [terr, tgrad] = ptv_nuclear_metric([], patch, pix_resolution, mask_cur, singular_coefs);
                err_N = err_N + terr;
                if abs_type == 1
                    tgrad = tgrad.*sign(patch0);
                elseif abs_type == 2
                    tgrad = tgrad .* patch0 ./ sqrt(patch0.^2 + deps);
                end
                if norm_type == 1
                    tgrad = tgrad - sum(sum(sum(tgrad, 1), 2), 3) / (size(patch,1)*size(patch,2)*size(patch,3));
                elseif norm_type == 2
                    tgrad = tgrad - mean(tgrad(:));
                elseif norm_type == 3
                    tgrad = tgrad - sum(sum( tgrad, 4), 5) / (size(patch,4)*size(patch,5));
                elseif norm_type == 4
                    tgrad = tgrad - sum(sum( tgrad, 4), 5) / (size(patch,4)*size(patch,5));
                    tgrad = tgrad - sum(sum(sum(tgrad, 1), 2), 3) / (size(patch,1)*size(patch,2)*size(patch,3));
                end
                sG(i1:i11, i2:i22, i3:i33, :) = tgrad;
            end
        end
        end
        end
    end
    err_N = err_N * prod(pix_resolution);
    sG = sG(1:volsz(1), 1:volsz(2), 1:volsz(3), :, :) * prod(pix_resolution);
end

% function [err_N, sG] = ptv_local_nuclear_metric(volfix, voldef, pix_resolution, mask, singular_coefs, P_SZ)
% %% todo:
% % * volfix
% % * zero mean, choose std???
% % * making zero mean changes gradient!
% 
% %     P_SZ = [15,15,15];
%     volsz = [size(voldef, 1), size(voldef, 2), size(voldef, 3)];
%     Nd = 3;
%     if volsz(3) == 1
%         Nd = 2;
%     end
%     
%     P_SZ = round(P_SZ);
%     Nimgs = size(voldef, 5);
%     if Nd == 2
%         P_SZ = [P_SZ, 1];
%     end
%     
%     volsz_p = ceil(volsz./P_SZ) .* P_SZ;
%     
%     if Nd == 2
%         volsz_p(3) = 1;
%     end
%   
%     voldef_p = zeros([volsz_p, 1, Nimgs]);
%     voldef_p(1:volsz(1), 1:volsz(2), 1:volsz(3), :, :) = voldef;
%     
%     if ~isempty(mask)
%         if Nd == 3
%             mask_p = zeros([volsz_p]);
%             mask_p(1:volsz(1), 1:volsz(2), 1:volsz(3)) = mask;
%         else
%             mask_p = zeros([volsz_p]);
%             mask_p(1:volsz(1), 1:volsz(2), 1) = mask;
%         end
%     end
% 
%     err_N = 0;
%     sG = zeros([volsz, Nimgs], 'like', voldef);
%     if Nd == 2
%         for i1 = 1 : P_SZ(1) : volsz(1)
%         for i2 = 1 : P_SZ(2) : volsz(2)
%             patch = voldef_p(i1:i1+P_SZ(1)-1, i2:i2+P_SZ(2)-1, 1, :, :);
%             patch = patch - sum(sum(sum(patch,1),2),3) / numel(patch);
% %             patch = patch ./ std(std(std(patch,[],1),[],2),[],3);
%             if ~isempty(mask)
%                 mask_cur = logical(mask_p(i1:i1+P_SZ(1)-1, i2:i2+P_SZ(2)-1));
%             else
%                 mask_cur = [];
%             end
%             if isempty(mask_cur) || any(mask_cur(:))
%                 [terr, tgrad] = ptv_nuclear_metric([], patch, pix_resolution, mask_cur, singular_coefs);
%                 err_N = err_N + terr;
%                 tgrad = tgrad - sum(sum(sum(tgrad, 1), 2), 3) / numel(patch);
%                 sG(i1:i1+P_SZ(1)-1, i2:i2+P_SZ(2)-1, 1, :) = tgrad;
%             end
%         end
%         end
%     else %3d
%         for i1 = 1 : P_SZ(1) : volsz(1)
%         for i2 = 1 : P_SZ(2) : volsz(2)
%         for i3 = 1 : P_SZ(3) : volsz(3)
%             patch = voldef_p(i1:i1+P_SZ(1)-1, i2:i2+P_SZ(2)-1, i3:i3+P_SZ(3)-1, :, :);
%             patch = patch - sum(sum(sum(patch,1),2),3) / numel(patch);
%             if ~isempty(mask)
%                 mask_cur = logical(mask_p(i1:i1+P_SZ(1)-1, i2:i2+P_SZ(2)-1, i3:i3+P_SZ(3)-1));
%             else
%                 mask_cur = [];
%             end
%             if isempty(mask_cur) || any(mask_cur(:))
%                 [terr, tgrad] = ptv_nuclear_metric([], patch, pix_resolution, mask_cur, singular_coefs);
%                 err_N = err_N + terr;
%                 sG(i1:i1+P_SZ(1)-1, i2:i2+P_SZ(2)-1, i3:i3+P_SZ(3)-1, :) = tgrad;
%             end
%         end
%         end
%         end
%     end
%     err_N = err_N * prod(pix_resolution);
%     sG = sG(1:volsz(1), 1:volsz(2), 1:volsz(3), :, :) * prod(pix_resolution);
% end