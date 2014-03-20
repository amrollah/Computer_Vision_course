clear; 
close all

% load image
I = imread('images\Img1.png');
image(I) ;

% converting to the gray scale
I = single(rgb2gray(I)) ;

% computing SIFT descriptors
[f,d] = vl_sift(I) ;

% visualizing a random selection of 50 features
perm = randperm(size(f,2)) ;
sel = perm(1:50) ;
h1 = vl_plotframe(f(:,sel)) ;
h2 = vl_plotframe(f(:,sel)) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;

% overlay the descpritors with grids
% h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
% set(h3,'color','g') ;





