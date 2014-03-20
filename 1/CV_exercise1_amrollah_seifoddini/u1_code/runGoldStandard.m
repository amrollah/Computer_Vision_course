function [K, R, t, error, newpts] = runGoldStandard(xy, XYZ)

%normalize data points
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);
%compute DLT
[Pn] = dlt(xy_normalized, XYZ_normalized);

%minimize geometric error
pn = [Pn(1,:) Pn(2,:) Pn(3,:)];
for i=1:20
    [pn] = fminsearch(@fminGoldStandard, pn, [], xy_normalized, XYZ_normalized, i/5);
end

%denormalize camera matrix
pn = reshape(pn,4,3)';
pn = pn / pn(3,4);
P = T\pn*U;
%factorize camera matrix in to K, R and t
[K, R, C] = decompose(P);
t = -R*C(1:3);
%compute reprojection error

newpts = P*XYZ;
newpts = newpts ./ repmat( newpts(3,:), 3, 1 );

err = 0;
for i=1:size(xy,2)
    err = err + norm(xy(1:2,i) - newpts(1:2,i))^2;   
end
error = err/size(xy,2);

end