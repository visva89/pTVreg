function A = create_2d_bilinear_interp_matrix(T, varargin)
% A = create_2d_bilinear_interp_matrix(T, [szin])
% T should contain displacements in pixels
% size(T) = [N, M, 2]
% 
% x_def = A * x(:);

sz = [size(T, 1), size(T, 2)];
if numel(varargin) == 1
    szin = varargin{1};
else
    szin = sz;
end

npixin = szin(1) * szin(2);
npixout = sz(1) * sz(2);

[m1, m2] = ndgrid(1:sz(1), 1:sz(2));
TT = T + cat(3, m1, m2);
rowidx = floor(TT(:, :, 1));
colidx = floor(TT(:, :, 2));
rowk = TT(:, :, 1) - rowidx;
colk = TT(:, :, 2) - colidx;
%
r = rowidx(:);
c = colidx(:);
s = (1 - rowk(:)) .* (1 - colk(:));
t = 1 : npixout;
idx = (r <= szin(1)) & (r >= 1) & (c <= szin(2)) & (c >= 1);
r = r(idx);
c = c(idx);
s = s(idx);
t = t(idx);
A = sparse(t, r + szin(1) * (c - 1), s, npixout, npixin);
%
r = rowidx(:) + 1;
c = colidx(:);
s = (rowk(:)) .* (1 - colk(:));
t = 1 : npixout;
idx = (r <= szin(1)) & (r >= 1) & (c <= szin(2)) & (c >= 1);
r = r(idx);
c = c(idx);
s = s(idx);
t = t(idx);
tmp = sparse(t, r + szin(1) * (c - 1), s, npixout, npixin);
A = A + tmp;
%
r = rowidx(:);
c = colidx(:) + 1;
s = (1 - rowk(:)) .* (colk(:));
t = 1 : npixout;
idx = (r <= szin(1)) & (r >= 1) & (c <= szin(2)) & (c >= 1);
r = r(idx);
c = c(idx);
s = s(idx);
t = t(idx);
tmp = sparse(t, r + szin(1) * (c - 1), s, npixout, npixin);
A = A + tmp;
%
r = rowidx(:) + 1;
c = colidx(:) + 1;
s = (rowk(:)) .* (colk(:));
t = 1 : npixout;
idx = (r <= szin(1)) & (r >= 1) & (c <= szin(2)) & (c >= 1);
r = r(idx);
c = c(idx);
s = s(idx);
t = t(idx);
tmp = sparse(t, r + szin(1) * (c - 1), s, npixout, npixin);
A = A + tmp;
end