% show image with key points
%
% Input:
%   img        - n x m color image 
%   corner     - 2 x k matrix, holding keypoint coordinates of first image
%   fig        - figure id
function showImageWithCorners(img, corners, fig)
    figure(fig);
    imshow(img, []);
    
    hold on, plot(corners(1,:), corners(2,:), '+r');

end