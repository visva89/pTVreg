function A = create_2d_bicubic_interp_matrix(T, varargin)
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

Kr = koefs(rowk);
Kc = koefs(colk);
for i = [-1, 0, 1, 2]
    for j = [-1, 0, 1, 2]
        r = rowidx(:) + i;
        c = colidx(:) + j;
        s = Kr{i+2} .* Kc{j+2};
        t = 1 : npixout;
        idx = (r <= szin(1)) & (r >= 1) & (c <= szin(2)) & (c >= 1);
        r = r(idx);
        c = c(idx);
        s = s(idx);
        t = t(idx);
        if i == -1 && j == -1 
            A = sparse(t, r + szin(1) * (c - 1), s, npixout, npixin);
        else
            A = A + sparse(t, r + szin(1) * (c - 1), s, npixout, npixin);
        end
    end
end
A = A/4;
end

function B = koefs(A)
    B{1} = A.*((2-A).*A-1);
    B{2} = A.^2.*(3*A-5)+2;
    B{3} = A.*((4-3*A).*A+1);
    B{4} = A.^2.*(A-1);
end