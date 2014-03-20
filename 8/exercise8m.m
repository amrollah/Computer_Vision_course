% =========================================================================
% Exercise 8
% =========================================================================
clc;clear;close all

% Initialize VLFeat (http://www.vlfeat.org/)
%addpath(genpath('vlfeat-0.9.17'));

%K Matrix for house images (approx.)
K = [  670.0000     0     393.000
         0       670.0000 275.000
         0          0        1];

%Load images
imgName1 = '../data/house.000.pgm';
imgName2 = '../data/house.004.pgm';

img1 = single(imread(imgName1));
img2 = single(imread(imgName2));

%extract SIFT features and match
[fa, da] = vl_sift(img1,'PeakThresh', 2);
[fb, db] = vl_sift(img2,'PeakThresh', 2);

%don't take features at the top of the image - only background   
filter = fa(2,:) > 100;
fa = fa(:,find(filter));
da = da(:,find(filter));

[matches, scores] = vl_ubcmatch(da, db);

showFeatureMatches(img1, fa(1:2, matches(1,:)), img2, fb(1:2, matches(2,:)), 20);

%% Compute essential matrix and projection matrices and triangulate matched points

%use 8-point ransac or 5-point ransac - compute (you can also optimize it to get best possible results)
%and decompose the essential matrix and create the projection matrices
t=0.002;
[F, inliers] = ransacfitfundmatrix(fa(1:2, matches(1,:)), fb(1:2, matches(2,:)), t);


%show epipolar lines
% show clicked points
figure(4), imshow(img1, []); hold on, plot(fa(1, matches(1,inliers(1,:))), fa(2, matches(1,inliers(1,:))), '*r');
figure(5), imshow(img2, []); hold on, plot(fb(1, matches(1,inliers(1,:))), fb(2, matches(1,inliers(1,:))), '*b');

% draw epipolar lines in img 1
figure(4)
for k = 1:size(inliers,2)
    drawEpipolarLines(F'*[fb(1:2, matches(2,inliers(1,k)));1], img1);
end

% draw epipolar lines in img 2
figure(5)
for k = 1:size(inliers,2)
    drawEpipolarLines(F*[fa(1:2, matches(1,inliers(1,k)));1], img2);
end


E=K'*F*K;

x1_calibrated=K\[fa(1:2, matches(1,inliers(1,:))); ones(1,size(inliers,2))];
x2_calibrated=K\[fb(1:2, matches(2,inliers(1,:))); ones(1,size(inliers,2))];

Ps{1} = eye(4);
Ps{2} = decomposeE(E, x1_calibrated, x2_calibrated);


%triangulate the inlier matches with the computed projection matrix
X = linearTriangulation(Ps{1}, x1_calibrated, Ps{2}, x2_calibrated);
figure(6)
plot3(X(1,:), X(2,:), X(3,:),'r*')

%% Add an addtional view of the scene 
imgName3 = '../data/house.001.pgm';
img3 = single(imread(imgName3));
[fc, dc] = vl_sift(img3,'PeakThresh', 2);

%match against the features from image 1 that where triangulated
[matches1, scores] = vl_ubcmatch(da(:,matches(1,inliers(1,:))), dc);    

%run 6-point ransac
x3_calibrated=K\[fc(1:2, matches1(2,:));ones(1,size(matches1,2)) ];
[Ps{3}, inliers2] = ransacfitprojmatrix(x3_calibrated(1:2,:), X(1:3,matches1(1,:)), t);

%triangulate the inlier matches with the computed projection matrix
X1 = linearTriangulation(Ps{1}, x1_calibrated(:,matches1(1,inliers2(1,:))), Ps{3}, x3_calibrated(:,inliers2(1,:)));
figure(6)
plot3(X1(1,:), X1(2,:), X1(3,:),'g*')
%% Add more views...
%% Add an addtional view of the scene 
%% image 1
imgName4 = '../data/house.002.pgm';
img4 = single(imread(imgName4));
[fd, dd] = vl_sift(img4,'PeakThresh', 2);

%match against the features from image 1 that where triangulated
[matches2, scores] = vl_ubcmatch(da(:,matches(1,inliers(1,:))), dd);    

%run 6-point ransac
x4_calibrated=K\[fd(1:2, matches2(2,:));ones(1,size(matches2,2)) ];
[Ps{4}, inliers3] = ransacfitprojmatrix(x4_calibrated(1:2,:), X(1:3,matches2(1,:)), t);

%triangulate the inlier matches with the computed projection matrix
X2 = linearTriangulation(Ps{1}, x1_calibrated(:,matches2(1,inliers3(1,:))), Ps{4}, x4_calibrated(:,inliers3(1,:)));
figure(6)
plot3(X2(1,:), X2(2,:), X2(3,:),'b*')
hold on
fig=6;

%% image2 
imgName5 = '../data/house.003.pgm';
img5 = single(imread(imgName5));
[ff, df] = vl_sift(img5,'PeakThresh', 2);

%match against the features from image 1 that where triangulated
[matches3, scores] = vl_ubcmatch(da(:,matches(1,inliers(1,:))), df);    

%run 6-point ransac
x5_calibrated=K\[ff(1:2, matches3(2,:));ones(1,size(matches3,2)) ];
[Ps{5}, inliers4] = ransacfitprojmatrix(x5_calibrated(1:2,:), X(1:3,matches3(1,:)), t);

%triangulate the inlier matches with the computed projection matrix
X3 = linearTriangulation(Ps{1}, x1_calibrated(:,matches3(1,inliers4(1,:))), Ps{5}, x5_calibrated(:,inliers4(1,:)));
figure(6)
plot3(X3(1,:), X3(2,:), X3(3,:),'c*')
hold on
drawCameras(Ps, fig);
%% Plot stuff

% fig = 10;
% figure(fig);

%use plot3 to plot the triangulated 3D points

%draw cameras
% drawCameras(Ps, fig);


%% bonus
%bonus_disp(imgName1,imgName2,Ps{1},Ps{2})

