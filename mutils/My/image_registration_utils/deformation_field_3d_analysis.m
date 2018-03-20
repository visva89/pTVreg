function [Sl1, Sl2, Jac] = deformation_field_3d_analysis(Tr, pixel_resolution)
% calculates sliding amount jacobian and other parameters of transformation
% Tr should be given in physical units (mm)!

dT = cell(3,3);
sz = size(Tr);
[m1,m2,m3] = ndgrid(1:sz(1), 1:sz(2), 1:sz(3));
mm{1} = m1;
mm{2} = m2;
mm{3} = m3;
for i1 = 1 : 3
    for i2 = 1: 3
        tmp = Tr(:,:,:,i1)+mm{i1}*pixel_resolution(i1);
        dT{i1,i2} = DGradient(tmp, [], i2) / pixel_resolution(i2);
    end
end

% EV = zeros([3, sz(1), sz(2), sz(3)]);
Sl1 = zeros([sz(1), sz(2), sz(3)]);
Sl2 = zeros([sz(1), sz(2), sz(3)]);
Jac = zeros([sz(1), sz(2), sz(3)]);
for i3 = 1 : sz(3)
for i2 = 1 : sz(2)
for i1 = 1 : sz(1)
    
    mat = [dT{1,1}(i1,i2,i3), dT{1,2}(i1,i2,i3), dT{1,3}(i1,i2,i3);...
           dT{2,1}(i1,i2,i3), dT{2,2}(i1,i2,i3), dT{2,3}(i1,i2,i3);...
           dT{3,1}(i1,i2,i3), dT{3,2}(i1,i2,i3), dT{3,3}(i1,i2,i3); ];
    
    mat_sym = mat'*mat;
    
    v = eig(mat_sym);
    v = sort(v);
    v = sqrt(abs(v));
    Sl1(i1,i2,i3) = (v(3)-v(1))/2;
    Sl2(i1,i2,i3) = v(3)/(v(2) + v(1));
    Jac(i1,i2,i3) = det(mat);
end
end
end

end