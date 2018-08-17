function H = displ_field_gradient_Nd(D, pix_resolution)
    Nd = size(D, 4);
    H = zeros([Nd,Nd, size(D, 1),size(D, 2), size(D, 3)]);
    for i = 1 : Nd
%         GS = cell(2,1);
        GS = {};
        if Nd == 2
            [GS{1}, GS{2}] = my_gradient( squeeze(D(:,:, 1, i)), pix_resolution, 0, 2);
        elseif Nd == 3
            [GS{1}, GS{2}, GS{3}] = my_gradient( squeeze(D(:,:,:, i)), pix_resolution, 0, 2);
        end
        
        for j = 1 : Nd
%             tmpD = imgaussfilt(D(:,:,i), 1.5);
%             tmpD = imgaussfilt(D(:,:,i), 1.9);
%             tmpD = D(:,:,i);
%             G = DGradient(tmpD, [], j) / pix_resolution(j);
              G = GS{j};
%             G = medfilt2(G, [3,3]);
%             G = imgaussfilt(G, 1.5);
            H(i, j, :, :, :) = G;
        end
    end
end