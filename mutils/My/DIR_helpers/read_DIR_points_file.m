function pts = read_DIR_points_file(fname)
    fid = fopen(fname, 'r');
    data = textscan(fid, '%f %f %f', 'headerlines', 0);
    fclose(fid);
    pts = [data{1}, data{2}, data{3}];
end