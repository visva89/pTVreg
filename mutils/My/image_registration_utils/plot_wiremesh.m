function plot_wiremesh(Tpix, d, style)
    tp = [];
    d  = round(d);
    hold on;
    T1 = Tpix(:,:,1);
    T2 = Tpix(:,:,2);
    for i = [1 : d : size(Tpix, 1), size(Tpix, 1)]
        js = [1 : d : size(Tpix, 2), size(Tpix, 2)];
        idxs = sub2ind(size(T1), i*ones(size(js)), js);
        plot(js + T2(idxs), i + T1(idxs), style);
    end
    
    for j = [1 : d : size(Tpix, 2), size(Tpix, 2)]
        is = [1 : d : size(Tpix, 1), size(Tpix, 1)];
        idxs = sub2ind(size(T1), is, j*ones(size(is)));
        plot(j + T2(idxs), is + T1(idxs), style);
    end
end