function Tcomp = compose_2d_displ(T1, T2)
    tc1 = movepixels_2d(T1(:, :, 1), T2, 1);
    tc2 = movepixels_2d(T1(:, :, 2), T2, 1);
    Tcomp = cat(3, tc1 + T2(:, :, 1), tc2 + T2(:, :, 2));
end