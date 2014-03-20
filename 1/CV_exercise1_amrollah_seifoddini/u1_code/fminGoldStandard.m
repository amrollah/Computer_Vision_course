function f = fminGoldStandard(p, xy, XYZ, w)

%reassemble P
P = [p(1:4);p(5:8);p(9:12)];

%compute squared geometric error
%compute cost function value
newpts = P*XYZ;
newpts = newpts ./ repmat( newpts(3,:), 3, 1 );
f = 0;
for i=1:size(xy,2)
f = f + norm(xy(:,i) - newpts(:,i))^2;
end
end