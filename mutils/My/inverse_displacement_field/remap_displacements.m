function [D_remap, vols_remap] = remap_displacements(D, refid, vols, spc)
    % remap_displacements(
    % 2d usage
    % D: S1xS2x1x2xN
    % vols: S1xS2x1xNxNch, default []
    % spc: 2x1, default [1,1]
    % 3d usage
    % D: S1xS2xS3x3xN
    % vols: S1xS2xS3xNxNch, default []
    % spc: 2x1, default [1,1,1]
    %
    % if 'D' are displacements that map vols into 'virtual' coordinate system, such
    % that imdeform(vols(:,:, i), D(:,:,:, i)) are 'registered' for all i,
    % then D_remap(:,:,:, refid) = 0 and 
    % vols(:,:, refid) is registered with imdeform(vols(:,:, i), D_remap(:,:,:, i))
    % If vols are provided (~=[]) then 
    %    vols_remap(:,:, i) = imdeform(vols(:,:, i), D_remap(:,:,:, i)),
    %    note that vols_remap(:,:, refid) \approx= vols(:,:, refid)
    % 
    % 'inverse_field' takes long, you can open matlab pool to parallelize 
    % invesrsion (parfor over dimensions).

    N = size(D, 5);
    nd = size(D, 4);
    spc = reshape(spc, [1,1,1, nd]);   
    D_pix = conv_3d_T_from_phys_to_pix(D, spc);
    Dref_pix = D_pix(:,:,:, :, refid);
%     invT0 = inverse_field(squeeze(D(:,:,:,:, refid) ./ spc));
    invDref_pix = inverse_field(squeeze(Dref_pix));
%     nnz(invDref_pix == 1337)
%     imagesc(invDref_pix(:,:, 40, 3)); colorbar; pause;
%     invDref_pix = mex_inverse_3d_displacements_double(squeeze(Dref_pix), 1);
%     invDref_pix=backwards2forwards(squeeze(Dref_pix));
%     invT0 = squeeze(D(:,:,:,:, refid) ./ spc);
    D_remap_pix = D * 0;
    vols_remap = [];
    if ~isempty(vols)
        vols_remap = 0 * vols;
    end
    for i = 1 : N
        tmpD = compose_displ(squeeze(D_pix(:,:,:,:, i)), invDref_pix, 1);
%         tmpD = compose_displ(invDref_pix, squeeze(D_pix(:,:,:,:, i)), 1);
        D_remap_pix(:,:,:,:, i) = reshape(tmpD,  size(D(:,:,:,:, 1)));
        if ~isempty(vols)
            Nch = size(vols, 4);
            for j = 1 : Nch
                if nd == 2
                    vols_remap(:,:,1, j, i) = imdeform2(vols(:,:,1, j, i), squeeze(D_remap_pix(:,:,1,:, i)), 1);
                elseif nd == 3
                    vols_remap(:,:,:, j, i) = imdeform3(vols(:,:,:, j, i), squeeze(D_remap_pix(:,:,:,:, i)), 1);
                end
            end
        end
    end
    D_remap = conv_T_from_pix_to_phys(D_remap_pix, spc);
end
