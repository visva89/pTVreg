function m = t_idx( i1, i2, N )
if i1 > i2
    tmp = i1;
    i1 = i2;
    i2 = tmp;
end
m = (i1-1)*N - i1*(i1-1)/2 - i1 + i2;
end

% return i1*N - i1*(i1+1)/2 - i1 + i2 - 1