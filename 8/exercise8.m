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
% %extract SIFT features and match
% [fa, da] = vl_sift(img1);
% [fb, db] = vl_sift(img2);
% 
% %don't take features at the top of the image - only background
% filter = fa(2,:) > 100;
% fa = fa(:,find(filter));
% da = da(:,find(filter));
% 
% [matches, scores] = vl_ubcmatch(da, db);
% 
load('vl_res.mat', 'fa', 'da','fb','db','matches');
showFeatureMatches(img1, fa(1:2, matches(1,:)), img2, fb(1:2, matches(2,:)), 20);
%% Task 1: Compute essential matrix and projection matrices and triangulate matched points

%use 8-point ransac or 5-point ransac - compute (you can also optimize it to get best possible results)
x1 = makehomogeneous(fa(1:2, matches(1,:)));
x2 = makehomogeneous(fb(1:2, matches(2,:)));
[x1n, T1] = normalise2dpts(x1);
[x2n, T2] = normalise2dpts(x2);

RANSAC_thresh = 0.003;
[F, inliers] = ransacfitfundmatrix(x1n, x2n, RANSAC_thresh);
E = K' * F * K; 
tfa = fa(1:2, matches(1,inliers(1,:)));
%and decompose the essential matrix and create the projection matrices

x1_calibrated = K\[fa(1:2, matches(1,inliers(1,:))); ones(1,size(inliers,2))];
x2_calibrated = K\[fb(1:2, matches(2,inliers(1,:))); ones(1,size(inliers,2))];

[x1_calibrated_n, T1] = normalise2dpts(x1_calibrated);
[x2_calibrated_n, T2] = normalise2dpts(x2_calibrated);

Ps{1} = eye(4);
Ps{2} = decomposeE(E, x1_calibrated_n, x2_calibrated_n);

%triangulate the inlier matches with the computed projection matrix
[X1, ~] = linearTriangulation(Ps{1}, x1_calibrated_n, Ps{2}, x2_calibrated_n);
%% Add an addtional view of the scene 

imgName3 = '../data/house.001.pgm';
img3 = single(imread(imgName3));
[fc, dc] = vl_sift(img3);

%match against the features from image 1 that where triangulated
[matches1, scores] = vl_ubcmatch(da(:,matches(1,inliers(1,:))), dc);
showFeatureMatches(img1, tfa(1:2, matches1(1,:)), img3, fc(1:2, matches1(2,:)), 21);
%run 6-point ransac
x3_calibrated = K\[fc(1:2, matches1(2,:));ones(1,size(matches1,2)) ];

[x3_calibrated_n, T3] = normalise2dpts(x3_calibrated);
[X1n, TX1] = normalise3dpts(X1);

[Ps{3}, inliers1] = ransacfitprojmatrix(x3_calibrated_n(1:2,:), X1n(1:3,matches1(1,:)), RANSAC_thresh);
X1_in = X1(1:3,matches1(1,inliers1(1,:)));
%triangulate the inlier matches with the computed projection matrix
[X2, ~] = linearTriangulation(Ps{1}, x1_calibrated_n(:,matches1(1,inliers1(1,:))), Ps{3}, x3_calibrated_n(:,inliers1(1,:)));

%% Task 2: Add more views...
imgName4 = '../data/house.002.pgm';
img4 = single(imread(imgName4));
[fc, dc] = vl_sift(img4);

%match against the features from image 1 that where triangulated
[matches2, scores] = vl_ubcmatch(da(:,matches(1,inliers(1,:))), dc);
showFeatureMatches(img1, tfa(1:2, matches2(1,:)), img4, fc(1:2, matches2(2,:)), 22);
%run 6-point ransac
x4_calibrated = K\[fc(1:2, matches2(2,:));ones(1,size(matches2,2)) ];
[x4_calibrated_n, T4] = normalise2dpts(x4_calibrated);

[Ps{4}, inliers2] = ransacfitprojmatrix(x4_calibrated_n(1:2,:), X1n(1:3,matches2(1,:)), RANSAC_thresh);

%triangulate the inlier matches with the computed projection matrix
[X3, ~] = linearTriangulation(Ps{1}, x1_calibrated_n(:,matches2(1,inliers2(1,:))), Ps{4}, x4_calibrated_n(:,inliers2(1,:)));

%%
% imgName5 = '../data/house.003.pgm';
% img5 = single(imread(imgName5));
% [fc, dc] = vl_sift(img5);
% 
% %match against the features from image 1 that where triangulated
% [matches3, scores] = vl_ubcmatch(da(:,matches(1,inliers(1,:))), dc);
% 
% %run 6-point ransac
% x5_calibrated = K\[fc(1:2, matches3(2,:));ones(1,size(matches3,2)) ];
% [Ps{5}, inliers3] = ransacfitprojmatrix(x5_calibrated(1:2,:), X1(1:3,matches3(1,:)), RANSAC_thresh);
% 
% %triangulate the inlier matches with the computed projection matrix
% [X4, ~] = linearTriangulation(Ps{1}, x1_calibrated(:,matches3(1,inliers3(1,:))), Ps{5}, x5_calibrated(:,inliers3(1,:)));

%% Task 3: Plot stuff

fig = 10;
figure(fig);

%use plot3 to plot the triangulated 3D points
hold on;
pl1 = plot3(X1_in(1,:),X1_in(2,:),X1_in(3,:),'r*');
pl2 = plot3(X2(1,:),X2(2,:),X2(3,:),'b*');
pl3 = plot3(X3(1,:),X3(2,:),X3(3,:),'g*');
% pl4 = plot3(X4(1,:),X4(2,:),X4(3,:),'y*');

set(pl1, 'MarkerSize', 4);
set(pl2, 'MarkerSize', 4);
set(pl3, 'MarkerSize', 4);
% set(pl4, 'MarkerSize', 4);

xlabel('x)')
ylabel('y)')
zlabel('z')
grid on
axis square

%draw cameras
drawCameras(Ps, fig);
hold off;