% =========================================================================
% Exercise 8
% =========================================================================
close all; clear; clc;
% Initialize VLFeat (http://www.vlfeat.org/)

%K Matrix for house images (approx.)
K = [  670.0000     0     393.000
         0       670.0000 275.000
         0          0        1];

%Load images
imgName1 = '../data/house.000.pgm';
imgName2 = '../data/house.004.pgm';

img1 = single(imread(imgName1));
img2 = single(imread(imgName2));
% 
%extract SIFT features and match
[fa, da] = vl_sift(img1);
[fb, db] = vl_sift(img2);

%don't take features at the top of the image - only background
filter = fa(2,:) > 100;
fa = fa(:,find(filter));
da = da(:,find(filter));

[matches, scores] = vl_ubcmatch(da, db);
 
% load('vl_res.mat', 'fa', 'da','fb','db','matches');
showFeatureMatches(img1, fa(1:2, matches(1,:)), img2, fb(1:2, matches(2,:)), 20);
%% Task 1: Compute essential matrix and projection matrices and triangulate matched points

%use 8-point ransac or 5-point ransac - compute (you can also optimize it to get best possible results)
x1 = fa(1:2, matches(1,:));
x2 = fb(1:2, matches(2,:));
RANSAC_thresh = 0.04;
[F, inliers] = ransacfitfundmatrix(x1, x2, RANSAC_thresh);

% draw epipolar lines in img 1
figure(1), imshow(img1, []); hold on, plot(fa(1, matches(1,inliers(1,:))), fa(2, matches(1,inliers(1,:))), '*r');

for k = 1:size(inliers,2)
    drawEpipolarLines(F'*[fb(1:2, matches(2,inliers(1,k)));1], img1);
end

% draw epipolar lines in img 2
figure(2), imshow(img2, []); hold on, plot(fb(1, matches(2,inliers(1,:))), fb(2, matches(2,inliers(1,:))), '*b');

for k = 1:size(inliers,2)
    drawEpipolarLines(F*[fa(1:2, matches(1,inliers(1,k)));1], img2);
end

showFeatureMatches(img1, fa(1:2, matches(1,inliers(1,:))), img2, fb(1:2, matches(2,inliers(1,:))), 27);
outliers = setdiff(matches(1,:),inliers(1,:));
showFeatureMatches(img1, fa(1:2, outliers), img2, fb(1:2, outliers), 28);

E = K' * F * K; 
tfa = fa(1:2, matches(1,inliers(1,:)));
%and decompose the essential matrix and create the projection matrices

x1_calibrated = K\[fa(1:2, matches(1,inliers(1,:))); ones(1,size(inliers,2))];
x2_calibrated = K\[fb(1:2, matches(2,inliers(1,:))); ones(1,size(inliers,2))];

Ps{1} = eye(4);
Ps{2} = decomposeE(E, x1_calibrated, x2_calibrated);

%triangulate the inlier matches with the computed projection matrix
[X1, ~] = linearTriangulation(Ps{1}, x1_calibrated, Ps{2}, x2_calibrated);

%% Add an addtional view of the scene 

imgName3 = '../data/house.001.pgm';
img3 = single(imread(imgName3));
[fc, dc] = vl_sift(img3);

%match against the features from image 1 that where triangulated
[matches1, scores] = vl_ubcmatch(da(:,matches(1,inliers(1,:))), dc);
showFeatureMatches(img1, tfa(1:2, matches1(1,:)), img3, fc(1:2, matches1(2,:)), 21);
%run 6-point ransac
x3_calibrated = K\[fc(1:2, matches1(2,:));ones(1,size(matches1,2)) ];
[Ps{3}, inliers1] = ransacfitprojmatrix(x3_calibrated(1:2,:), X1(1:3,matches1(1,:)), RANSAC_thresh);
outliers1 = setdiff(matches1(1,:),inliers1(1,:));
showFeatureMatches(img1, fa(1:2, outliers1), img3, fc(1:2, outliers1), 22);

if (det(Ps{3}(1:3,1:3)) < 0 )
    Ps{3}(1:3,1:3) = -Ps{3}(1:3,1:3);
    Ps{3}(1:3, 4) = -Ps{3}(1:3, 4);
end

X1_in = X1(1:3,matches1(1,inliers1(1,:)));
%triangulate the inlier matches with the computed projection matrix
[X2, ~] = linearTriangulation(Ps{1}, x1_calibrated(:,matches1(1,inliers1(1,:))), Ps{3}, x3_calibrated(:,inliers1(1,:)));

%% Task 2: Add more views...
imgName4 = '../data/house.002.pgm';
img4 = single(imread(imgName4));
[fc, dc] = vl_sift(img4);

%match against the features from image 1 that where triangulated
[matches2, scores] = vl_ubcmatch(da(:,matches(1,inliers(1,:))), dc);
showFeatureMatches(img1, tfa(1:2, matches2(1,:)), img4, fc(1:2, matches2(2,:)), 23);
%run 6-point ransac
x4_calibrated = K\[fc(1:2, matches2(2,:));ones(1,size(matches2,2)) ];
[Ps{4}, inliers2] = ransacfitprojmatrix(x4_calibrated(1:2,:), X1(1:3,matches2(1,:)), RANSAC_thresh);
outliers2 = setdiff(matches2(1,:),inliers2(1,:));
showFeatureMatches(img1, fa(1:2, outliers2), img4, fc(1:2, outliers2), 24);

if (det(Ps{4}(1:3,1:3)) < 0 )
    Ps{4}(1:3,1:3) = -Ps{4}(1:3,1:3);
    Ps{4}(1:3, 4) = -Ps{4}(1:3, 4);
end

%triangulate the inlier matches with the computed projection matrix
[X3, ~] = linearTriangulation(Ps{1}, x1_calibrated(:,matches2(1,inliers2(1,:))), Ps{4}, x4_calibrated(:,inliers2(1,:)));

%%
imgName5 = '../data/house.003.pgm';
img5 = single(imread(imgName5));
[fc, dc] = vl_sift(img5);

%match against the features from image 1 that where triangulated
[matches3, scores] = vl_ubcmatch(da(:,matches(1,inliers(1,:))), dc);
showFeatureMatches(img1, tfa(1:2, matches3(1,:)), img5, fc(1:2, matches3(2,:)), 25);
%run 6-point ransac
x5_calibrated = K\[fc(1:2, matches3(2,:));ones(1,size(matches3,2)) ];
[Ps{5}, inliers3] = ransacfitprojmatrix(x5_calibrated(1:2,:), X1(1:3,matches3(1,:)), RANSAC_thresh);
outliers3 = setdiff(matches3(1,:),inliers3(1,:));
showFeatureMatches(img1, fa(1:2, outliers3), img5, fc(1:2, outliers3), 26);

if (det(Ps{5}(1:3,1:3)) < 0 )
    Ps{5}(1:3,1:3) = -Ps{5}(1:3,1:3);
    Ps{5}(1:3, 4) = -Ps{5}(1:3, 4);
end

%triangulate the inlier matches with the computed projection matrix
[X4, ~] = linearTriangulation(Ps{1}, x1_calibrated(:,matches3(1,inliers3(1,:))), Ps{5}, x5_calibrated(:,inliers3(1,:)));

%% Task 3: Plot stuff

fig = 10;
figure(fig);

%use plot3 to plot the triangulated 3D points
hold on;
pl1 = plot3(X1_in(1,:),X1_in(2,:),X1_in(3,:),'r*');
pl2 = plot3(X2(1,:),X2(2,:),X2(3,:),'b*');
pl3 = plot3(X3(1,:),X3(2,:),X3(3,:),'g*');
pl4 = plot3(X4(1,:),X4(2,:),X4(3,:),'y*');

set(pl1, 'MarkerSize', 4);
set(pl2, 'MarkerSize', 4);
set(pl3, 'MarkerSize', 4);
set(pl4, 'MarkerSize', 4);

xlabel('x)')
ylabel('y)')
zlabel('z')
grid on

%draw cameras
drawCameras(Ps, fig);
hold off;