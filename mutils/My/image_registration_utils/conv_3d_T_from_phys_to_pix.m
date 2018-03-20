function Tpix = conv_3d_T_from_phys_to_pix(Tphys, spc)
    Tpix = Tphys;
    for j = 1 : size(Tphys, 5)
    for i = 1 : size(Tphys, 4)
        Tpix(:,:,:, i, j) = Tpix(:,:,:,i, j) / spc(i);
    end
    end
end