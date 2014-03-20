clickPoints = false;

% image names 
imgName1 = 'images/img1.jpg';
imgName2 = 'images/img2.jpg';

% read in images
img1 = im2double(imread(imgName1));
img2 = im2double(imread(imgName2));

[pathstr1, name1] = fileparts(imgName1);
[pathstr2, name2] = fileparts(imgName2);

cacheFile = [pathstr1 filesep 'matches_' name1 '_vs_' name2 '.mat'];

% get point correspondences
if (clickPoints)
    [x1s, x2s] = getClickedPoints(img1, img2);
	save(cacheFile, 'x1s', 'x2s', '-mat');
else
	load('-mat', cacheFile, 'x1s', 'x2s');
end

% show clicked points
figure(1),clf, imshow(img1, []); hold on, plot(x1s(1,:), x1s(2,:), '*r');  
figure(2),clf, imshow(img2, []); hold on, plot(x2s(1,:), x2s(2,:), '*r');

[Fh, F] = fundamentalMatrix(x1s, x2s);

% draw epipolar lines in img 1
figure(1)
for k = 1:size(x1s,2)
    drawEpipolarLines(Fh'*x2s(:,k), img1);
end
% draw epipolar lines in img 2
figure(2)
for k = 1:size(x2s,2)
    drawEpipolarLines(Fh*x1s(:,k), img2);
end


%show epipolar line for a new point
image_to_clic=1;
figure(image_to_clic)
newp=ginput(1);newp=[newp 1]';
plot(newp(1), newp(2), '*g')
figure(3-image_to_clic)
if image_to_clic==1
  figure(2);drawEpipolarLines(Fh*newp, img2);
else
  figure(1);drawEpipolarLines(Fh'*newp, img1);
end

