function varargout = warp_gradient(img_mov, T, pix_resolution, interp_type, out_val_type)
if ndims(img_mov) == 2
    %nargout = 2
    Ic1 = floor(T(:, :, 1)) + 1;
    If1 = floor(T(:, :, 1));
    Ic2 = floor(T(:, :, 2)) + 1;
    If2 = floor(T(:, :, 2));
    G1 = imdeform2(img_mov, cat(3, Ic1, T(:,:,2)), interp_type, out_val_type) - imdeform(img_mov, cat(3, If1, T(:,:,2)), interp_type, out_val_type);
    G2 = imdeform2(img_mov, cat(3, T(:,:,1), Ic2), interp_type, out_val_type) - imdeform(img_mov, cat(3, T(:,:,1), If2), interp_type, out_val_type);
    varargout{1} = G1 / pix_resolution(1);
    varargout{2} = G2 / pix_resolution(2);
elseif ndims(img_mov) == 3
    %nargout = 3
    If1 = floor(T(:, :, :, 1));
    Ic1 = If1 + 1;
    If2 = floor(T(:, :, :, 2));
    Ic2 = If2 + 1;
    If3 = floor(T(:, :, :, 3));
    Ic3 = If3 + 1;
    
    G1 = imdeform3(img_mov, cat(4, Ic1, T(:,:,:,2), T(:,:,:,3)), interp_type, out_val_type) ...
       - imdeform3(img_mov, cat(4, If1, T(:,:,:,2), T(:,:,:,3)), interp_type, out_val_type);
    G2 = imdeform3(img_mov, cat(4, T(:,:,:,1), Ic2, T(:,:,:,3)), interp_type, out_val_type) ...
       - imdeform3(img_mov, cat(4, T(:,:,:,1), If2, T(:,:,:,3)), interp_type, out_val_type);
    G3 = imdeform3(img_mov, cat(4, T(:,:,:,1), T(:,:,:,2), Ic3), interp_type, out_val_type) ...
       - imdeform3(img_mov, cat(4, T(:,:,:,1), T(:,:,:,2), If3), interp_type, out_val_type);
   
    varargout{1} = G1 / pix_resolution(1);
    varargout{2} = G2 / pix_resolution(2);
    varargout{3} = G3 / pix_resolution(3);
end
end