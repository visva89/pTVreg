function y = lut_fun(x, lut_table, lut_signs, varargin)
    i0 = 1;
    if numel(varargin) > 0
        i0 = 1 + varargin{1};
    end
    y = lut_table(round(x * (10^lut_signs)) + i0);
    y = reshape(y, size(x));
end