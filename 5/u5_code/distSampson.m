function d = distSampson( X1, F,  X2)

X2t_F_X1= X2'*F*X1;
F_X1 = F*X1;
Ft_X2 = F'*X2;

d =  X2t_F_X1.^2 ./ (F_X1(1,:).^2 + F_X1(2,:).^2 + Ft_X2(1,:).^2 + Ft_X2(2,:).^2);

end

