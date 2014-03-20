% Compute the fundamental matrix using the eight point algorithm
% Input 
% 	x1s, x2s 	Point correspondences
%
% Output
% 	Fh 			Fundamental matrix with the det F = 0 constraint
% 	F 			Initial fundamental matrix obtained from the eight point algorithm
%
function [Fh, F] = fundamentalMatrix(x1s, x2s)
% Normalization
[x1, T1] = normalizePoints2d(x1s);
[x2, T2] = normalizePoints2d(x2s);
npts = size(x1s,2);

% The constraint matrix
A = [x2(1,:)'.*x1(1,:)'   x2(1,:)'.*x1(2,:)'  x2(1,:)' ...
     x2(2,:)'.*x1(1,:)'   x2(2,:)'.*x1(2,:)'  x2(2,:)' ...
     x1(1,:)'             x1(2,:)'            ones(npts,1) ];       

[U,D,V] = svd(A,0);
F = reshape(V(:,9),3,3)';
% Enforce constraint that fundamental matrix has rank 2 by performing
% a svd and then reconstructing with the two largest singular values.
[U,D,V] = svd(F,0);
Fh = U*diag([D(1,1) D(2,2) 0])*V';

% Denormalise
Fh = T2'*F*T1;
end