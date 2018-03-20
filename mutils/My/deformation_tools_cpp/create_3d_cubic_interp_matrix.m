function A = create_3d_cubic_interp_matrix(T, varargin)
% A = create_3d_bilinear_interp_matrix(T, [szin])
% T should contain displacements in pixels
% size(T) = [sz1, sz2, sz3, 3]
% 
% x_def = A * x(:);

sz = [size(T, 1), size(T, 2), size(T, 3)];
if numel(varargin) == 1
    szin = varargin{1};
else
    szin = sz;
end
npixin = szin(1) * szin(2) * szin(3);
npixout = sz(1) * sz(2) * sz(3);

[m1, m2, m3] = ndgrid(1:sz(1), 1:sz(2), 1:sz(3));
TT = T + cat(4, m1, m2, m3);
rowidx = floor(TT(:, :, :, 1));
colidx = floor(TT(:, :, :, 2));
dolidx = floor(TT(:, :, :, 3));
rowk = TT(:, :, :, 1) - rowidx;
colk = TT(:, :, :, 2) - colidx;
dolk = TT(:, :, :, 3) - dolidx;

Kr = koefs(rowk);
Kc = koefs(colk);
Kd = koefs(dolk);

for i = [-1, 0, 1, 2]
    for j = [-1, 0, 1, 2]
        for k = [-1, 0, 1, 2]
%             [i,j,k]
            r = rowidx(:) + i;
            c = colidx(:) + j;
            d = dolidx(:) + k;
            s = Kr{i+2} .* Kc{j+2} .* Kd{k+2};
            t = 1 : npixout;
            idx = (r <= szin(1)) & (r >= 1) & (c <= szin(2)) & (c >= 1) & (d >= 1) & (d <= szin(3));
            
            r = r(idx);
            c = c(idx);
            d = d(idx);
            s = s(idx);
            t = t(idx);
            
            sp_c_idx = r + szin(1) * (c - 1) + szin(1)*szin(2)* (d - 1);

            if i == -1 && j == -1 && k == -1
                A = sparse(t, sp_c_idx, s, npixout, npixin);
            else
                tmp = sparse(t, sp_c_idx, s, npixout, npixin);
                A = A + tmp;
            end
        end
    end
end
A = A/8;
end

function B = koefs(A)
    B{1} = A.*((2-A).*A-1);
    B{2} = A.^2.*(3*A-5)+2;
    B{3} = A.*((4-3*A).*A+1);
    B{4} = A.^2.*(A-1);
end