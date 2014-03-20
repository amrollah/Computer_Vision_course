% Exercice 2
%
close all;

IMG_NAME = 'images/image001.jpg';

%This function displays the calibration image and allows the user to click
%in the image to get the input points. Left click on the chessboard corners
%and type the 3D coordinates of the clicked points in to the input box that
%appears after the click. You can also zoom in to the image to get more
%precise coordinates. To finish use the right mouse button for the last
%point.
%You don't have to do this all the time, just store the resulting xy and
%XYZ matrices and use them as input for your algorithms.
%[xy XYZ] = getpoints(IMG_NAME);
%save('data.mat', 'xy', 'XYZ');
load('data.mat');
img = imread(IMG_NAME);
image(img);
axis image;
hold on;
plot(xy(1,:),xy(2,:),'ro');
% === Task 2 DLT algorithm ===

[K, R, t, error, newpts] = runDLT(xy, XYZ);

% === Task 3 Gold Standard algorithm ===

%[K, R, t, error, newpts] = runGoldStandard(xy, XYZ);

% === Bonus: Gold Standard algorithm with radial distortion estimation ===

%[K, R, t, error] = runGoldStandardRadial(xy, XYZ);

plot(newpts(1,:),newpts(2,:),'b*');
hold off;
