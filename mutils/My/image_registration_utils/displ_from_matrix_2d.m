
function T = displ_from_matrix_2d(M, imsz, cached, varargin)
    use_left_ref = false;
    if nargin > 3
        use_left_ref = varargin{1};
    end
        
    if ~isempty(cached)
        q = cached.q;
        m1 = cached.m1;
        m2 = cached.m2;
    else
        [m1, m2] = ndgrid(1:imsz(1), 1:imsz(2));
        if ~use_left_ref
            m1 = m1 - imsz(1)/ 2;
            m2 = m2 - imsz(2)/ 2;
        end
    end
   
    
    Tx = (M(1,1) - 1) * m1 + M(1,2) * m2 + M(1,3);
    Ty = M(2,1) * m1 + (M(2,2)-1) * m2 + M(2,3);
    
%     Tx = (M(1,1) ) * m1 + M(1,2) * m2 + M(1,3);
%     Ty = M(2,1) * m1 + (M(2,2)) * m2 + M(2,3);
%     norm(Tyy - Ty)
    
    T = cat(3, Tx, Ty);
end