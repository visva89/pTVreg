function implay_2d_deform(imgs, imgsdef, Tm, spacing, do_pause, cl)
i = 1;
while true
    subplot(121);
    hold off;
    imagesc((imgsdef(:,:, i))); colormap gray; 
    if ~isempty(cl)
        caxis(cl)
    end
    subplot(122);
    hold off;
    imagesc(imgs(:,:, i));
    if ~isempty(cl)
        caxis(cl)
    end
    hold on;
    plot_wiremesh(Tm(:,:,:, i), spacing, 'r-');
    title(num2str(i));
    pause(0.05);
    
    i = i + 1;
    if i > size(imgs, 3)
        i = 1;
    end
    if do_pause
        pause;
    end
end

end