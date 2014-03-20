function [xyn, XYZn, T, U] = normalization(xy, XYZ)

%data normalization
% to ensure homogeneous coordinates have scale of 1
xy(1,:) = xy(1,:)./xy(3,:);
xy(2,:) = xy(2,:)./xy(3,:);
xy(3,:) = 1;

XYZ(1,:) = XYZ(1,:)./XYZ(4,:);
XYZ(2,:) = XYZ(2,:)./XYZ(4,:);
XYZ(3,:) = XYZ(3,:)./XYZ(4,:);
XYZ(4,:) = 1;

%first compute centroid
xy_centroid = mean(xy(1:2,:)')';
XYZ_centroid = mean(XYZ(1:3,:)')';

xyc(1,:) = xy(1,:)-xy_centroid(1); % Shift origin to centroid.
xyc(2,:) = xy(2,:)-xy_centroid(2);
   
XYZc(1,:) = XYZ(1,:)-XYZ_centroid(1); % Shift origin to centroid.
XYZc(2,:) = XYZ(2,:)-XYZ_centroid(2);
XYZc(3,:) = XYZ(3,:)-XYZ_centroid(3);
    
%then, compute scale
xy_meandist = sqrt(xyc(1,:).^2 + xyc(2,:).^2);   
xy_meandist = mean(xy_meandist(:));
Tscale = sqrt(2)/xy_meandist;

XYZ_meandist = sqrt(XYZc(1,:).^2 + XYZc(2,:).^2 + XYZc(3,:).^2);
XYZ_meandist = mean(XYZ_meandist(:));
Uscale = sqrt(3)/XYZ_meandist;

%create T and U transformation matrices
T = [Tscale   0   -Tscale*xy_centroid(1)
     0     Tscale -Tscale*xy_centroid(2)
     0       0      1      ];

U = [Uscale  0     0      -Uscale*XYZ_centroid(1)
     0     Uscale  0      -Uscale*XYZ_centroid(2)
     0       0   Uscale   -Uscale*XYZ_centroid(3)
     0       0     0        1    ];

%and normalize the points according to the transformations
xyn = T*xy;
XYZn = U*XYZ;

end