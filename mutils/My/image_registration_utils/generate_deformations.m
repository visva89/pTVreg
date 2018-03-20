function Ts = generate_deformations(Nimgs, imsz, spacing, K)

szK = ceil(imsz ./ spacing) + 3;
Ts = cell(Nimgs);

for i = 2 : Nimgs
    Knots = K * (rand([szK , 2]) - 0.5) ;
%     Ts{1, i} = mex_2d_linear_disp(Knots, size(imgs{1}), spacing);
    Ts{1, i} = mex2dffddisp_new(Knots, imsz, spacing);
end
Ts{1,1} = zeros(size(Ts{1,2}));

for i = 1 : Nimgs
    iT2 = inverse_transformation(Ts{1, i});
    for j = 1 : Nimgs
        Ts{i, j} = compose_2d_displ(iT2, Ts{1, j});
    end
end

end