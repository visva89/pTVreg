function y = bessels(x, type, varargin)
    lut_table = [];
    lut_signs = [];
    if numel(varargin) >= 2
        lut_table = varargin{1};
        lut_signs = varargin{2};
    end
    if strcmp(type, 'I0')
        
    elseif strcmp(type, 'logI0')
        idxs = x >= 120;
        idxm = x < 0;
        y = x*0;
        y(idxs) = x(idxs) - 1/2 * log(2*pi*x(idxs));
        
        idd = (~idxs) & (~idxm);
        if ~isempty(lut_table)
            y(idd) = lut_table(round(x(idd) * 10^lut_signs) + 1);
        else
            y(idd) = log(besseli(0, x(idd)));
        end
        
    elseif strcmp(type, 'I1I0')
        idxs = x >= 120;
        idxm = x < 0;
        y = x*0;
        y(idxs) = 1;
        
        idd = (~idxs) & (~idxm);
        if ~isempty(lut_table)
            y(idd) = lut_table(round(x(idd) * 10^lut_signs) + 1);
        else
            y(idd) = besseli(1, x(idd))./besseli(0, x(idd));
        end
        
    end
end