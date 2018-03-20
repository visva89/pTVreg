function [TransMat, Displ] = estimate_affine_from_displ(T, mask)
    % TransMat - transformation matrix for homogeneous coordinates
    % Displ - displacement field for estimated affine transformation 
    %
    % T - displacement field to be approximated
    % mask - pixels used for approximation. [] -- ones(size(T))
    
    % Example usage
    % alpha = 0.2; 
    % t1=5; t2=-9; 
    % TT = displ_from_matrix_2d([cos(alpha), -sin(alpha), t1; sin(alpha), cos(alpha), t2; 0, 0, 1], [256,256], [], true);
    % [et1, et2, ealpha, eTransMat, eDispl] = estimate_rigid_from_displ(TT);
    % (1 - norm(fl(TT-Displ))/norm(fl(TT))) * 100 % -- percent explained by a rigid rotation
    
    ftype = 3; 
    
    sz = [size(T, 1), size(T, 2)];
    [n1, n2] = ndgrid(1:sz(1), 1:sz(2));
    T(:,:,1) = T(:,:,1) + n1;
    T(:,:,2) = T(:,:,2) + n2;
    ND = cat(3, n1, n2);
    
    if isempty(mask)
        mask = ones(size(T, 1), size(T, 2));
    end
    mask = logical(mask);
    
    T = reshape(T, [size(T,1)*size(T, 2), 2]);
    ND = reshape(ND, [size(ND,1)*size(ND, 2), 2]);
    T = T(mask, :)';
    ND = ND(mask, :)';
    
%     T = [T];% ones(1, size(T, 2))];
    ND = [ND; ones(1, size(ND, 2))];
   
    x0 = [eye(2), zeros(2,1)];
    opts = [];
    opts.display = 'off';
    if ftype == 1
        objf = @(x) fgval(x, T, ND);
        xmin = minFunc(objf, x0(:), opts);
    elseif ftype == 2
        objf = @(x) fval(x, T, ND);
        opts.numDiff = 2;
        xmin = minFunc(objf, x0(:), opts);
    elseif ftype == 3
        options = optimoptions('fminunc','Display', 'off', 'Algorithm', 'quasi-newton');
        objf = @(x) fval(x, T, ND);
        xmin = fminunc(objf, x0(:), options);
    end
    TransMat = reshape(xmin, [2,3]);
    TransMat = [TransMat; [0, 0, 1]];
    Displ = displ_from_matrix_2d(TransMat, sz, [], true);
end
 
function f = fval(Mat, T, ND)
    Mat = reshape(Mat, [2,3]);
    Mat = [Mat; 0,0,1];
    ptsm = Mat * ND;
    ptsm = ptsm(1:2, :);
    f = sum(sqrt( sum((T - ptsm).^2, 1) ));
end

function [f, g] = fgval(Mat, T, ND)
    dx = 0.00001;
    dx = 1e-6;
    
    f = fval(Mat, T, ND);
    g = Mat(:) * 0;
    for i = 1 : numel(Mat)
        xtmp = Mat(:);
        xtmp(i) = xtmp(i) + dx;
        fp = fval(xtmp, T, ND);
        g(i) = (fp - f) / dx;
    end
end