function Tcomp = compose_2d_displacements(T1, T2)
    tc1 = imdeform(T1(:, :, 1), T2, 1);
    tc2 = imdeform(T1(:, :, 2), T2, 1);
    Tcomp = cat(3, tc1 + T2(:, :, 1), tc2 + T2(:, :, 2));
end