% extract descriptor
%
% Input:
%   keyPoints     - detected keypoints in a 2 x n matrix holding the key
%                   point coordinates
%   img           - the gray scale image
%   
% Output:
%   descr         - m x n matrix, stores for each keypoint a
%                   descriptor. m is the size of the image patch,
%                   represented as vector
function descr = extractDescriptor(corners, img)  
wr = 4; % window_radious
descr=zeros(size(corners,2), (2*wr+1)*(2*wr+1));
[r, c] = size(img);

for i=1:size(corners,2)
    x=corners(1,i);
    y=corners(2,i);

    if((x-wr)>=1 && (y-wr)>=1 && (y+wr) <= c && (x+wr) <= r)
        patch=img((x-wr:x+wr),(y-wr:y+wr));
        descr(i,:)=patch(:)';
    end
end
end