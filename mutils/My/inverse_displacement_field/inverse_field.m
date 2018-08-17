function [iT] =  inverse_field(T)
    % inverse displacement field
    % size(T) = [N, M, 2] or 
    % size(T) = [N, M, K, 3]
    %
    sz = size(T);    
    if ndims(T) == 3
        T(:,:, 1) = imgaussfilt(T(:,:,1), 1.3);
        T(:,:, 2) = imgaussfilt(T(:,:,2), 1.3);
        
        [n1, n2] = ndgrid(1:sz(1), 1:sz(2));
        fB1 = griddata(T(:,:,1) + n1, T(:,:,2) + n2, n1, n1, n2, 'cubic') - n1;
        fB2 = griddata(T(:,:,1) + n1, T(:,:,2) + n2, n2, n1, n2, 'cubic') - n2;
        iT = cat(3, fB1, fB2);    
        
%         [n1, n2] = ndgrid(1:sz(1), 1:sz(2));
%         F = scatteredInterpolant(fl(T(:,:,1) + n1), fl(T(:,:,2) + n2), fl(n1), 'natural', 'nearest');
%         fB1 = F(n1, n2) - n1;
%         F = scatteredInterpolant(fl(T(:,:,1) + n1), fl(T(:,:,2) + n2), fl(n2), 'natural', 'nearest');
%         fB2 = F(n1, n2) - n2;
%         iT = cat(3, fB1, fB2);    
    elseif false%ndims(T) == 4 && size(T,4) == 3 && isa(T, 'double')
        sgm = 1.3;
%         sgm = 0.5;
        T = cat(4, imgaussfilt3(T(:,:,:, 1), sgm), imgaussfilt3(T(:,:,:, 2), sgm), imgaussfilt3(T(:,:,:, 3), sgm));
        iT = mex_inverse_3d_displacements_double(T, 1);
    elseif ndims(T) == 4
        fB = cell(3, 1);
        n = cell(3, 1);
        [n{1}, n{2}, n{3}] = ndgrid(1:sz(1), 1:sz(2), 1:sz(3));
        parfor i = 1:3
%             tic
%             F = scatteredInterpolant(fl(T(:,:,:,1) + n{1}), fl(T(:,:,:,2) + n{2}), fl(T(:,:,:,3) + n{3}), fl(n{i}));
%             tmp = F({1:sz(1), 1:sz(2), 1:sz(3)}) - n{i};
%             toc
%             imagesc(tmp(:,:, 4)); pause;
%             tic
            fB{i} = griddata(T(:,:,:,1) + n{1}, T(:,:,:,2) + n{2}, T(:,:,:,3) + n{3}, ...
                n{i}, n{1}, n{2}, n{3}, 'linear') - n{i};
%             toc
%             imagesc(fB{i}(:,:,4)); pause;
%             imagesc(abs(fB{i}(:,:,4) - tmp(:,:,4))); colorbar; pause;
        end
            
%         fB1 = griddata(T(:,:,:,1) + n1, T(:,:,:,2) + n2, T(:,:,:,3) + n3, ...
%             n1, n1, n2, n3, 'linear') - n1;
%         fB2 = griddata(T(:,:,:,1) + n1, T(:,:,:,2) + n2, T(:,:,:,3) + n3, ...
%             n2, n1, n2, n3, 'linear') - n2;
%         fB3 = griddata(T(:,:,:,1) + n1, T(:,:,:,2) + n2, T(:,:,:,3) + n3, ...
%             n3, n1, n2, n3, 'linear') - n3;
        iT = cat(4, fB{1}, fB{2}, fB{3});    
    end
    iT(isnan(iT))=0;
end