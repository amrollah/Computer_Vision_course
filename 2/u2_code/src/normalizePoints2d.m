% Normalization of 2d-pts
% Inputs: 
%           x1s = 2d points
% Outputs:
%           nxs = normalized points
%           T = normalization matrix
function [nxs, T] = normalizePoints2d(x1s)
%data normalization
% to ensure homogeneous coordinates have scale of 1
xy(1,:) = x1s(1,:)./x1s(3,:);
xy(2,:) = x1s(2,:)./x1s(3,:);
xy(3,:) = 1;

%first compute centroid
xy_centroid = mean(xy(1:2,:)')';
xyc(1,:) = xy(1,:)-xy_centroid(1); % Shift origin to centroid.
xyc(2,:) = xy(2,:)-xy_centroid(2);
   

xy_meandist = sqrt(xyc(1,:).^2 + xyc(2,:).^2);   
xy_meandist = mean(xy_meandist(:));
Tscale = sqrt(2)/xy_meandist;

%create T and U transformation matrices
T = [Tscale   0   -Tscale*xy_centroid(1)
     0     Tscale -Tscale*xy_centroid(2)
     0       0      1      ];

%and normalize the points according to the transformations
nxs = T*x1s;
end