clc; clear; close all;
path(path, 'sift');
path(path, 'GCmex1.3');

imgNameL = 'images\0018.png';
imgNameR = 'images\0019.png';
camNameL = 'images\0018.camera';
camNameR = 'images\0019.camera';

% scale = 0.5^3;
scale = 0.5^2;

imgL = imresize(imread(imgNameL), scale);
imgR = imresize(imread(imgNameR), scale);

[K R C] = readCamera(camNameL);
PL = K * [R,-R*C];
[K R C] = readCamera(camNameR);
PR = K * [R,-R*C];

[imgRectL, imgRectR, Hleft, Hright, maskL, maskR] = getRectifiedImages(imgL,imgR);
close all;

se = strel('square',15);
maskL = imerode(maskL,se);
maskR = imerode(maskR,se);
threshLR = 8;
RANSAC_thresh = 0.8;
% Window size
winsize=5;
%% ========================================================================
    % part 1) extract SIFT features and match
    [fa, da] = extractSIFT(rgb2gray(imgRectL));
    [fb, db] = extractSIFT(rgb2gray(imgRectR));
    figure(25);
    image(imgRectL);
    % visualizing a random selection of 100 sift features
    perm = randperm(size(fa,2)) ;
    sel = perm(1:100) ;
    h1 = plotsiftframe(fa(:,sel)) ;
    h2 = plotsiftframe(fa(:,sel)) ;
    set(h1,'color','k','linewidth',3) ;
    set(h2,'color','y','linewidth',2) ;
    saveas(25,'images\fig25_sift_img1.png');
    
    figure(26);
    image(imgRectR);
    perm = randperm(size(fb,2)) ;
    sel = perm(1:100) ;
    h1 = plotsiftframe(fb(:,sel)) ;
    h2 = plotsiftframe(fb(:,sel)) ;
    set(h1,'color','k','linewidth',3) ;
    set(h2,'color','y','linewidth',2) ;
    saveas(26,'images\fig26_sift_img2.png');
    
    [matches, scores] = siftmatch(da, db);

    %show matches
    showFeatureMatches(imgRectL, fa(1:2, matches(1,:)), imgRectR, fb(1:2, matches(2,:)), 1);
    saveas(1,'images\fig1_sift_match.png');
    
%     save('sift_results.mat','fa','fb','matches', 'RANSAC_thresh');
    load('sift_results.mat','fa','fb','matches', 'RANSAC_thresh');
%% set disparity range automatically (bonus)
[inliers1, inliers2, ~, ~, ~, ~] = ransac5pE(fa(1:2, matches(1,:)), fb(1:2, matches(2,:)), RANSAC_thresh, K);
% [inliers1, inliers2, ~, ~, ~, ~] = ransac8pF_adaptive_sampson(fa(1:2, matches(1,:)), fb(1:2, matches(2,:)), RANSAC_thresh);
in_diff = inliers2 - inliers1;
min_disp = max(-40,ceil(min(in_diff(1,:))));
max_disp = min(40,ceil(max(in_diff(1,:))));
dispRangeLR = min_disp:max_disp;
dispRangeRL = -max_disp:-min_disp;

% dispRangeLR = -30:30;
% dispRangeRL = -30:30;

% %% compute disparities, winner-takes-all
% % exercise 5.1
% 
dispStereoL = stereoDisparity(rgb2gray(imgRectL), rgb2gray(imgRectR), dispRangeLR, winsize);
dispStereoR = stereoDisparity(rgb2gray(imgRectR), rgb2gray(imgRectL), dispRangeRL, winsize); 
 
maskLRcheck = leftRightCheck(dispStereoL,dispStereoR,threshLR);
maskRLcheck = leftRightCheck(dispStereoR,dispStereoL,threshLR);

maskStereoL = double(maskL).*maskLRcheck;
maskStereoR = double(maskR).*maskRLcheck;
figure(2);
imshow(mat2gray(dispStereoL));
saveas(2,'images\fig2_dispStereoL.png');
figure(3);
imshow(mat2gray(dispStereoR));
saveas(3,'images\fig3_dispStereoR.png');

%% compute disparities using graphcut
% exercise 5.2
Labels = gcDisparity(rgb2gray(imgRectL), rgb2gray(imgRectR), dispRangeLR, winsize);
dispsGCL = double(Labels + dispRangeLR(1));
Labels = gcDisparity(rgb2gray(imgRectR), rgb2gray(imgRectL), dispRangeRL, winsize);
dispsGCR = double(Labels + dispRangeRL(1));

maskLRcheck = leftRightCheck(dispsGCL,dispsGCR,threshLR);
maskRLcheck = leftRightCheck(dispsGCR,dispsGCL,threshLR);

maskGCL = double(maskL).*maskLRcheck;
maskGCR = double(maskR).*maskRLcheck;

figure(4);
imshow(mat2gray(dispsGCL));
saveas(4,'images\fig4_dispsGCL.png');
figure(5);
imshow(mat2gray(dispsGCR));
saveas(5,'images\fig5_dispsGCR.png');


%% for each pixel (x,y), compute the corresponding 3D point! Use S for computing
% the rescaled points with the projection matrices PL PR
% exercise 5.3
S = [scale 0 0;0 scale 0;0 0 1];
imwrite(imgRectR,'imgRectR.png');
imwrite(imgRectL,'imgRectL.png');

% coordsWTA = generatePointCloudFromDisps(dispStereoL,PL,PR,S);
% generateObjFile('model3d','imgRectL.png',coordsWTA,maskStereoL);

coordsGC = generatePointCloudFromDisps(dispsGCL,PL,PR,S);
generateObjFile('model3d','imgRectL.png',coordsGC,maskGCL);
