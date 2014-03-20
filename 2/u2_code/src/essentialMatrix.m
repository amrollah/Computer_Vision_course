% Compute the essential matrix using the eight point algorithm
% Input 
% 	x1s, x2s 	Point correspondences 3xn matrices
%
% Output
% 	Eh 			Essential matrix with the det F = 0 constraint and the constraint that the first two singular values are equal
% 	E 			Initial essential matrix obtained from the eight point algorithm
%

function [Eh, E] = essentialMatrix(x1n, x2n)
npts = size(x1n,2);
% The constraint matrix
 A=[x2n(1,:)'.*x1n(1,:)'   x2n(1,:)'.*x1n(2,:)'   x2n(1,:)' ...
   x2n(2,:)'.*x1n(1,:)'   x2n(2,:)'.*x1n(2,:)'   x2n(2,:)' ....
   x1n(1,:)'              x1n(2,:)'              ones(npts, 1)];
% Compute the SVD
[U,S,V] = svd(A);
E = reshape(V(:,9),3,3)';
% Compute the SVD of E
[U,S,V] = svd(E);

S = diag([ (S(1,1)+S(2,2))/2  (S(1,1)+S(2,2))/2  0 ]);
% Enforce Singularity constraint
Eh = U*S*V';
end