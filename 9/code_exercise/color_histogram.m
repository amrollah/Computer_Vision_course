function hist = color_histogram(x1,y1,x2,y2,img,nBins)
x1 = floor(x1);
x2 = floor(x2);
y1 = floor(y1);
y2 = floor(y2);
sizeFrame = size(img);
H = zeros([nBins nBins nBins]);
for i=x1:x2
    for j=y1:y2
        if (j <= sizeFrame(1) && j > 0 && i <= sizeFrame(2) && i > 0)
            p = double(reshape(img(j,i,:), [1 3]));
            p = floor(p/(256/nBins)) + 1;
            H(p(1),p(2),p(3)) = H(p(1),p(2),p(3)) + 1;
        end
    end
end

hist = H(:);
end