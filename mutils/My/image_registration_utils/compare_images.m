function errinfo = compare_images(img_fix, imdef)
% usage:
% compare_images(imfix, imdef);

errinfo = struct();
N = numel(img_fix);
errinfo.mserr = sqrt(sum((img_fix(:) - imdef(:)).^2)) / N;
errinfo.abserr = sum(abs(img_fix(:) - imdef(:))) / N;
errinfo.corerr = -1;

R = min(50, floor(size(img_fix, 1)/3));
C = min(50, floor(size(img_fix, 2)/3));
errinfo.mserr_part =  sqrt(sum(sum( (img_fix(R:end-R, C:end-C) - imdef(R:end-R, C:end-C) ).^2 ))) / N;
errinfo.abserr_part = sum(sum( abs(img_fix(R:end-R, C:end-C) - imdef(R:end-R, C:end-C) ) )) / N;
errinfo.corerr_part = -1;
end