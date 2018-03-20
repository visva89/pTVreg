function pivotmat = tensor2pivotmat(tensor, dim)
    pmt = 1 : ndims(tensor);
    pmt(1) = dim;
    pmt(dim) = 1;
    pivotmat = permute(tensor, pmt);
    sz = size(pivotmat);
    psz = prod(sz(2:end));
    pivotmat = reshape(pivotmat, [sz(1), psz]);
end