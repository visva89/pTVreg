function vol = read_dir_img(fname, sz)
    fid = fopen(fname, 'rb');
    vol = fread(fid, sz(1)*sz(2)*sz(3), '*int16');
    vol = reshape(vol, sz);
    fclose(fid);
end