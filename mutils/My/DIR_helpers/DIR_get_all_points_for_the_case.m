function pts = DIR_get_all_points_for_the_case(caseN, basepth) 
    cn = num2str(caseN);
    path = [basepth, ...
            '4dCT/Case', cn, 'Pack/Case', cn, 'Pack/ExtremePhases/'];
    pts = struct();
    pts.extreme.b = read_DIR_points_file([path, 'Case', cn, ...
        '_300_T00_xyz.txt']);
    pts.extreme.e = read_DIR_points_file([path, 'Case', cn, ...
        '_300_T50_xyz.txt']);
    
    path2 = [basepth, ...
            '4dCT/Case', cn, 'Pack/Case', cn, 'Pack/Sampled4D/'];
    for i = 1 : 6
        ni = num2str(i - 1);
        pts.smp{i}.pts = read_DIR_points_file([path2, 'case', cn, ...
            '_4D-75_T', ni, '0.txt']);
    end
end