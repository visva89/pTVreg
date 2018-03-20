function Tphys = conv_T_from_pix_to_phys(Tpix, spc)
    spc = reshape(spc, [1,1,1, numel(spc), 1]);
    Tphys = Tpix .* spc;
%     for j = 1 : size(Tphys, 5)
%     for i = 1 : size(Tphys, 4)
%         Tpix(:,:,:, i, j) = Tpix(:,:,:,i, j) * spc(i);
%     end
%     end
end