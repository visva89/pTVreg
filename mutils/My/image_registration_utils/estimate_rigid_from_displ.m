function [t1, t2, alpha, TransMat, Displ] = estimate_rigid_from_displ(T, mask)
    % t1 - translation in first dimension
    % t2 - translation in second dimension
    % alpha - angle (in radians). Rotation is performed around (0,0) point.
    %           keep in mind, that upper left pixel has index (1,1).
    % TransMat - transformation matrix for homogeneous coordinates
    % Displ - displacement field for estimated rigid transformation 
    %
    % T - displacement field to be approximated
    %
    % Example usage
    % alpha = 0.2; 
    % t1=5; t2=-9; 
    % TT = displ_from_matrix_2d([cos(alpha), -sin(alpha), t1; sin(alpha), cos(alpha), t2; 0, 0, 1], [256,256], [], true);
    % [et1, et2, ealpha, eTransMat, eDispl] = estimate_rigid_from_displ(TT);
    % (1 - norm(fl(TT-Displ))/norm(fl(TT))) * 100 % -- percent explained by a rigid rotation
    if isempty(mask)
        mask = ones(size(T, 1), size(T, 2));
    end
    mask = logical(mask);
    
    sz = [size(T, 1), size(T, 2)];
    [n1, n2] = ndgrid(1:sz(1), 1:sz(2));
    T(:,:,1) = T(:,:,1) + n1;
    T(:,:,2) = T(:,:,2) + n2;
    ND = cat(3, n1, n2);
    
    T = reshape(T, [size(T,1)*size(T, 2), 2]);
    ND = reshape(ND, [size(ND,1)*size(ND, 2), 2]);
    T = T(mask, :)';
    ND = ND(mask, :)';
    T = [T; ones(1, size(T, 2))];
    ND = [ND; ones(1, size(ND, 2))];
    
    opts = [];
    opts.display = 'off';
    objf = @(x) fgval(x(1), x(2), x(3), T, ND);
%     fl = @(x) x(:);
%     x0 = [mean(fl(T(:,:,1))); mean(fl(T(:,:,2))); 0];
    x0 = [0;0;0];
    xmin = minFunc(objf, x0, opts);
    t1 = xmin(1);
    t2 = xmin(2);
    alpha = xmin(3) * pi / 180;
    TransMat = [cos(alpha), -sin(alpha), t1; ...
                sin(alpha), cos(alpha), t2; ...
                0, 0, 1];
    Displ = displ_from_matrix_2d(TransMat, sz, [], true);
end
 
function f = fval(t1, t2, alpha, T, ND)
    alpha = alpha * pi / 180; % just to keep t1,t2 and alpha in the same scale
    
%     pts = reshape(T, [size(T,1)*size(T,2), 2]);
%     pts = [pts, ones(size(pts,1), 1)]';
%     pts0 = reshape(ND, [size(T,1)*size(T,2), 2]);
%     pts0 = [pts0, ones(size(pts0,1), 1)]';
     
    ca = cos(alpha);
    sa = sin(alpha);
    R = [ca, -sa, t1; sa, ca, t2; 0, 0, 1];
%     ptsm = R * pts0;
%     f = sum(sqrt( sum( mask.*(pts - ptsm).^2, 1) ));
    ptsm = R * ND;
    f = sum(sqrt( sum((T - ptsm).^2, 1) ));
end
 
function [f, g] = fgval(t1, t2, alpha, T, ND)
    dx = 0.001;
    dx = 1e-5;
     
    f = fval(t1,t2,alpha,T, ND);
    fp1 = fval(t1 + dx, t2, alpha, T, ND);
    fp2 = fval(t1, t2 + dx, alpha, T, ND);
    fp3 = fval(t1, t2, alpha + dx, T, ND);
    g = [(fp1 - f) / dx; (fp2 - f) / dx; (fp3 - f) / dx];
end