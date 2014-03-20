% Decompose the essential matrix
% Return P = [R|t] which relates the two views
% Yu will need the point correspondences to find the correct solution for P
function P = decomposeE(E, x1s, x2s)
% Compute SVD of E
[U,S,V] = svd(E);

W = [0 -1 0; 1 0 0; 0 0 1];

R1 = U*W*V';
R2 = U*W'*V';
T1 = U(:,3);
T2 = -U(:,3);       

%Compute the four possible solutions
P4 = zeros(3,4,4);
P4(:,:,1) = [R1, T1];
P4(:,:,2) = [R1, T2];
P4(:,:,3) = [R2, T1];
P4(:,:,4) = [R2, T2];

P1 = [eye(3), zeros(3,1)];
for i = 1:4 
    [XS, err] = linearTriangulation(P1, x1s(:,1), P4(:,:,i), x2s(:,1));
    
    %Compute the corresponding image point for the origin camera(first camera)
    xn1 = P1(:,:)*XS;

    %Compute the corresponding image point for the second camera
    xn2 = P4(:,:,i)*XS;

    % Check if the reprojected point is visible in both cameras.
    if(xn1(3)>0 && xn2(3)>0)
        P = P4(:,:,i);
        break;
    end;
end

end