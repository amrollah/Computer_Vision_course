function disp = stereoDisparity(img1, img2, dispRange, winsize)

img1=im2double(img1);
img2=im2double(img2);

% Disparities 
[r c]=size(img1);
ssd=zeros(r,c,length(dispRange));

for i=1:length(dispRange)    
    img1Shifted = shiftImage( img1, dispRange(i) );
    SSD=(img2-img1Shifted).^2;
    
    H = fspecial('average',winsize);
    SSD=conv2(SSD,H,'same');
    
    ssd(:,:,i)= SSD;
end

[val index]=min(ssd,[],3);

disp=reshape(dispRange(index(:)),r,c);

end