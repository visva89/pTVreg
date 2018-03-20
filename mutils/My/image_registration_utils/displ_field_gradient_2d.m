function H = displ_field_gradient_2d(D, pix_resolution)
    H = zeros([2,2,size(D, 1),size(D, 2)]);
    for i = 1 : 2
%         GS = cell(2,1);
        [GS{1}, GS{2}] = my_gradient(D(:,:,i), [1,1], 0, 2);
        for j = 1 : 2
%             tmpD = imgaussfilt(D(:,:,i), 1.5);
%             tmpD = imgaussfilt(D(:,:,i), 1.9);
            tmpD = D(:,:,i);
%             G = DGradient(tmpD, [], j) / pix_resolution(j);
              G = GS{j};
%             G = medfilt2(G, [3,3]);
%             G = imgaussfilt(G, 1.5);
            H(i, j, :, :) = G;
        end
    end
end