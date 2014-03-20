function [K, R, t, error, newpts] = runDLT(xy, XYZ)

%normalize data points
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);

%compute DLT
[P_normalized] = dlt(xy_normalized, XYZ_normalized);

%denormalize camera matrix
P = T\P_normalized*U;
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