clear; 
close all
 
% load images
I1 = imread('images\I1.jpg');
I2 = imread('images\I2.jpg');

% converting to gray scale
Ia = single(rgb2gray(I1)) ;
Ib = single(rgb2gray(I2)) ;

% extracting and matching the descriptors
[fa, da] = vl_sift(Ia, 'PeakThresh', 8) ;
[fb, db] = vl_sift(Ib, 'PeakThresh', 8) ;
[matches, scores] = vl_ubcmatch(da, db) ;

% showing the matched descriptors in two images
showFeatureMatches(I1, fa(1:2, matches(1,:)), I2, fb(1:2, matches(2,:)), 20);






