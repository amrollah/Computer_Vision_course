function diffs = diffsGC(img1, img2, dispRange, winsize)

img1=im2double(img1);
img2=im2double(img2);

% get data costs for graph cut
% calculate the data cost per cluster center
[r c]=size(img1);
diffs=zeros(r,c,length(dispRange));

for i=1:length(dispRange) 
    img1Shifted = shiftImage( img1, dispRange(i) );
    SSD=(img2-img1Shifted).^2;
    
    H = fspecial('average',winsize);
    SSD=conv2(SSD,H,'same');
    
    diffs(:,:,i)= SSD;
end
