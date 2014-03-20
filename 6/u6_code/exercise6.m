function exercise6()
clc; clear; close all;

% load image
img = imread('cow.jpg');
% for faster debugging we decrease the size of image
scale = 0.3;
img = imresize(img, scale);
%figure, imshow(img), title('original image')

%% smooth image (6.1a)
% smoothing the image
imgSmoothed = imfilter(img,fspecial('gauss',[5 5],0.5),'symmetric');
%figure, imshow(imgSmoothed), title('smoothed image')
%% convert to L*a*b* image (6.1b)
cform = makecform('srgb2lab');
imglab = applycform(imgSmoothed,cform);
%figure, imshow(imglab), title('l*a*b* image')

%% (6.2) Mean Shift Segmentation
[mapMS peaks] = meanshiftSeg(imglab);
visualizeSegmentationResults (mapMS,peaks);

%% (6.3) EM Segmentation
K=5;
[mapEM cluster] = EM(imglab,K);
visualizeSegmentationResults (mapEM,cluster');

end