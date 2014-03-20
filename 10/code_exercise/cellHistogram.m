function H = cellHistogram(magnitudes, angles, numBins)
binSize = pi / numBins;
minAngle = 0;

angles(angles < 0) = angles(angles < 0) + pi;
leftBinIndex = round((angles - minAngle) / binSize);
rightBinIndex = leftBinIndex + 1;
leftBinCenter = ((leftBinIndex - 0.5) * binSize) - minAngle;

rightPortions = angles - leftBinCenter;
leftPortions = binSize - rightPortions;
rightPortions = rightPortions / binSize;
leftPortions = leftPortions / binSize;

leftBinIndex(leftBinIndex == 0) = numBins;
rightBinIndex(rightBinIndex == (numBins + 1)) = 1;

H = zeros(1, numBins);
for i = 1:numBins
    pixels = (leftBinIndex == i);
    H(1, i) = H(1, i) + sum(leftPortions(pixels)' * magnitudes(pixels));
    
    pixels = (rightBinIndex == i);
        
    H(1, i) = H(1, i) + sum(rightPortions(pixels)' * magnitudes(pixels));
end    

end