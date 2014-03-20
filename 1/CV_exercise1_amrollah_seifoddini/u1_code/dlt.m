function [P] = dlt(xy, XYZ)
%computes DLT, xy and XYZ should be normalized before calling this function
% Arrange the matrix A. Only the first two equations are needed as the
% last one is redundant
A = zeros(2*size(xy,2),12);
for i=1:size(xy,2) 
    A(2*i-1,:) = [XYZ(1,i),XYZ(2,i),XYZ(3,i),1, 0,0,0,0             -xy(1,i)*XYZ(1,i),-xy(1,i)*XYZ(2,i),-xy(1,i)*XYZ(3,i),-xy(1,i)];
    A(2*i,:)   = [0,0,0,0            -XYZ(1,i),-XYZ(2,i), -XYZ(3,i), -1, xy(2,i)*XYZ(1,i), xy(2,i)*XYZ(2,i), xy(2,i)*XYZ(3,i), xy(2,i)];
end;    
% Obtain SVD of A
[U,S,V] = svd(A);
% The matrix H is composed of the elements of the last vector of V
h = V(:,end);
% Reorganice h to obtain H
P = reshape(h,4,3)';
P = P / P(3,4);
end

