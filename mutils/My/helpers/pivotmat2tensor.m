function tensor = pivotmat2tensor(pivotmat, dim, tensorsz)
    ndims = numel(tnsorsz);
    pmt = 1 : ndims;
    pmt(1) = dim;
    pmt(dim) = 1;
    
    sz = tensorz;
    sz(1) = sz(dim);
    sz(dim) = tensorsz(1);
    
    pivotmat = reshape(pivotmat, sz);
    tensor = permute(pivotmat, pmt);
end