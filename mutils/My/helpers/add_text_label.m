function add_text_label(x, y, ipos, str, fontsize, interp, textcolor, ishift)
% Define position to display the text
i = round(ipos);
if ~isempty(ishift)
    i = round(ipos+ishift);
end
% Get the local slope
d1 = (y(i+1)-y(i-1))/(x(i+1)-x(i-1));
d2 = (y(i+2)-y(i))/(x(i+2)-x(i-2));
d3 = (y(i)-y(i-2))/(x(i)-x(i-2));
d = mean([d1,d2,d3]);
d = (y(i+1)-y(i-1))/(x(i+1)-x(i-1));
i = round(ipos);

X = diff(get(gca, 'xlim'));
Y = diff(get(gca, 'ylim'));
p = pbaspect;
a = atan(d*p(2)*X/p(1)/Y)*180/pi;

% Display the text
mg = 0.1;
if ~isempty(fontsize) && ~isempty(interp)
    text(x(i), y(i), str, 'BackgroundColor', 'w', 'rotation', a, 'fontsize', fontsize, 'interpreter', interp, 'color', textcolor, 'margin', mg);
elseif ~isempty(interp)
    text(x(i), y(i), str, 'BackgroundColor', 'w', 'rotation', a, 'interpreter', interp, 'margin', mg);
elseif ~isempty(fontsize)
    text(x(i), y(i), str, 'BackgroundColor', 'w', 'rotation', a, 'fontsize', fontsize, 'margin', mg);
end

end