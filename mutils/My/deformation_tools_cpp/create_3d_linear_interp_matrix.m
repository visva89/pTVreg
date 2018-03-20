function A = create_3d_linear_interp_matrix(T, varargin)
% A = create_2d_bilinear_interp_matrix(T, [szin])
% T should contain displacements in pixels
% size(T) = [N1, N2, N3, 2]
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

r = cell(3, 1);
rk = cell(3, 1);
for i = 1 : 3
    r{i} = floor(TT(:, :, :, i));
    rk{i} = TT(:,:,:, i) - r{i};
end

%
ssh =  [0, 0, 0, 0, 1, 1, 1, 1;...
        0, 1, 0, 1, 0, 1, 1, 0;...
        0, 0, 1, 1, 0, 0, 1, 1;];
A = sparse(npixout, npixin);
for i = 1 : 8
    t = 1 : npixout;
    s = ones(numel(rk{1}), 1);
    rid = cell(3, 1);
    for j = 1 : 3
        rid{j} = r{j} + ssh(j, i);
        if ssh(j, i) == 1
            tmps = rk{j};
        else
            tmps = 1 - rk{j};
        end
        s = s .* tmps(:);
    end
    idx = (rid{1} <= szin(1)) & (rid{1} >= 1) & (rid{2} <= szin(2)) & (rid{2} >= 1) & (rid{3} <= szin(3)) & (rid{3} >= 1);
    for j = 1 : 3
        rid{j} = rid{j}(idx);
    end
    s = s(idx);
    t = t(idx);
    tmp = sparse(t, rid{1} + szin(1) * (rid{2} - 1) + szin(2)*szin(1) * (rid{3} - 1), s, npixout, npixin);
    A = A + tmp;
end

end