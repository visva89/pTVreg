function savegif(filename, newvol, delay)
    if ndims(newvol) == 3
        N_frame  = size(newvol,3);
    else
        N_frame = size(newvol, 4);
    end
    for frame = 1:N_frame
        if ndims(newvol) == 3
            Itt = uint8(newvol(:,:,frame)*255);
            Itt = repmat(Itt, [1,1,3]);
        elseif ndims(newvol) == 4
            Itt = uint8(newvol(:,:,:,frame)*255);
        end
        %size(Itt);
        [SIf,cm] = rgb2ind(Itt,256);
        
        % Save to a GIF.
        if ( frame == 1 )
            imwrite( SIf,cm, filename, 'gif', 'WriteMode', 'overwrite', ...
            'DelayTime', delay, 'LoopCount', inf );
        else
            imwrite( SIf,cm, filename, 'gif', 'WriteMode', 'append', ...
            'DelayTime', delay);
        end; % if-else
    %     M(frame) = im2frame(Itt,map);
    end
end
