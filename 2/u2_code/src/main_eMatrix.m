clickPoints = false;

imgName1 = 'images/img1.jpg';
imgName2 = 'images/img2.jpg';
      
K = 1.0e+03 * [3.5341 0 1.8105; 0 3.5633 0.6595; 0 0 0.0010];
	
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
figure(1), imshow(img1, []); hold on, plot(x1s(1,:), x1s(2,:), '*r');  
figure(2), imshow(img2, []); hold on, plot(x2s(1,:), x2s(2,:), '*b');

% Normalization
x1n = K\x1s;
x2n = K\x2s;

[Eh, E] = essentialMatrix(x1n, x2n);

F = (inv(K)'*E)\K;

% draw epipolar lines in img 1
figure(1)
for k = 1:size(x1s,2)
    drawEpipolarLines(F'*x2s(:,k), img1);
end
% draw epipolar lines in img 2
figure(2)
for k = 1:size(x2s,2)
    drawEpipolarLines(F*x1s(:,k), img2);
end

%origin camera
P1 = eye(4);

% compute the camera matrix
P2 = decomposeE(E, K\x1s, K\x2s); %Note that normalized points should be used
P2(4, :)=[0 0 0 1];
P2 = P2 ./ P2(4,4);

%show triangulated points
X = linearTriangulation(P1, K\x1s, P2, K\x2s);
figure(3), hold off, plot3(X(1,:), X(2,:), X(3,:), '.r');hold on

% show cameras
showCameras({P1, P2}, 3);


