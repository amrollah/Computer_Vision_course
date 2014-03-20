% extract harris corner
%
% Input:
%   img           - n x m gray scale image
%   thresh        - scalar value to threshold corner strength
%   
% Output:
%   corners       - 2 x k matrix storing the keypoint coordinates
%   H             - n x m gray scale image storing the corner strength
function [corners, H] = extractHarrisCorner(img, thresh)
% calc the gradient of image
[Ix, Iy] = gradient(img,3);

% blurring the Harris matrix xomponents with gaussian filter
fil = fspecial('gaussian', 5, 2);
Ix2 = imfilter(Ix.^2,fil);
Iy2 = imfilter(Iy.^2,fil);
Ixy = imfilter(Ix.*Iy,fil);

% forming Harris matrix
H=[Ix2 Ixy; Ixy Iy2];

% calc the Harris response.
K_global =(Ix2.*Iy2-Ixy.^2) ./ (Ix2 + Iy2 + eps);

% show histogram of Harris corner strength values
hist(K_global (:),50);

% non max supperss
window_size = 3;
mx = ordfilt2(K_global,window_size^2,ones(window_size,window_size)); % apply 3X3 maximum filter on corner strength matrix
% a mask to limit the keypoints within the image boundary and window size. 
boundarymask = zeros(size(K_global));
boundarymask(2:end-1, 2:end-1) = 1;
% Find maxima, threshold, and apply bordermask
 K_points = (K_global==mx) & (K_global>thresh) & boundarymask;
% K_points = (K_global>thresh) & boundarymask; % for the case without non-max suppression
% Find rows and columns of keypoints. 
[r,c] = find(K_points);

corners = [r'; c'];
end