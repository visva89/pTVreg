function [Ts, Mats] = generate_affine_deformations(Nimgs, imsz, T, k, non)

MMs = cell(Nimgs, 1);
Ts = cell(Nimgs);
Mats = cell(Nimgs);
MMs{1}= [1, 0, 0; 0, 1, 0; 0, 0, 1];
for i = 2 : Nimgs
    tmp = [1, 1, T/k; 1, 1, T/k; 0, 0, 0];
    if i <= non
        tmp = 0;
    end
    
    MM = [1, 0, 0; 0, 1, 0; 0, 0, 1] + tmp .* (rand(3)-0.5)*k;
    
%     t = rand() - 0.5;
%     MM = [cos(t), -sin(t), 0; sin(t), cos(t), 0; 0,0,1];
    MMs{i} = MM;
end

for i = 1 : Nimgs
    for j = 1 : Nimgs
        if i == j, continue; end;
        matt = MMs{j} * inv(MMs{i});
        Ts{i, j} = displ_from_matrix_2d(matt, imsz, []);
        Mats{i, j} = matt;
    end
end
end