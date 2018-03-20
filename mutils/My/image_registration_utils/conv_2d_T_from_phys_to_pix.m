function Tpix = conv_2d_T_from_phys_to_pix(Tphys, spc)
    Tpix = Tphys;
    Tpix(:,:,1) = Tpix(:,:,1) / spc(1);
    Tpix(:,:,2) = Tpix(:,:,2) / spc(2);
end