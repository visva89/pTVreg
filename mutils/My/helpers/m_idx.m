function idx = m_idx(i1, i2, N ) 
    idx = (N-1) * (i1-1) + (i2-1) - double(i2>i1) + 1;
end
