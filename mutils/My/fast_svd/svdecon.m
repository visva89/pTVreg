function [U,S,V] = svdecon(X)
% Input:
% X : m x n matrix
%
% Output:
% X = U*S*V'
%
% Description:
% Does equivalent to svd(X,'econ') but faster
%
% Vipin Vijayan (2014)

%X = bsxfun(@minus,X,mean(X,2));
[m,n] = size(X);

if  m <= n
    C = X*X';
    [U,D] = eig(C);
    clear C;
    
    [d,ix] = sort(abs(diag(D)),'descend');
    U = U(:,ix);    
    
    if nargout > 2
        V = X'*U;
        s = sqrt(d);
        V = V ./ (s'+eps);
%         V = bsxfun(@(x,c)x./c, V, s');
        S = diag(s);
    end
else
    C = X'*X; 
    [V,D] = eig(C);
    clear C;
    
    [d,ix] = sort(abs(diag(D)),'descend');
    V = V(:,ix);    
    
    U = X*V; % convert evecs from X'*X to X*X'. the evals are the same.
    %s = sqrt(sum(U.^2,1))';
    s = sqrt(d);

    U = U ./ (s'+eps);
%     U = bsxfun(@(x,c)x./c, U, s');
   
    S = diag(s);
end

% if any(fl(isnan(U))) || any(fl(isnan(S))) || any(fl(isnan(V)))
%     warning('Nan in svd');
%     
%     fprintf('Nan in svd ########################\n');
%     std(X(:))
%     mean(X(:))
%     X
%     imagesc(X); colorbar; pause;
% S
% [U, S, V] = svd(X, 'econ');
% end