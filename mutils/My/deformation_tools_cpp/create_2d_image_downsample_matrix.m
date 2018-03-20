function A = create_2d_image_downsample_matrix(szin, k)
    szout = ceil(szin / k);
    
    npixin = prod(szin);
    npixout = prod(szout);
    
    A = sparse(npixout, npixin);
    [m1, m2] = ndgrid(1:szin(1), 1:szin(2));
    
    mm1 = ceil(m1 / k);
    mm2 = ceil(m2 / k);
    
    m1 = m1(:); m2 = m2(:);
    mm1 = mm1(:); mm2 = mm2(:);
    
    rr = (mm2-1)*szout(1) + mm1;
    cc = (m2-1)*szin(1) + m1;
    A = sparse(rr, cc, 1/k^2, npixout, npixin);
    
%     return;
    
end