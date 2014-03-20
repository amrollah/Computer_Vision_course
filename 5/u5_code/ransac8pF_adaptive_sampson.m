function [in1, in2, out1, out2, m, F] = ransac8pF(xy1, xy2, threshold)

% make points homogeneous
xy1=[xy1; ones(1, size(xy1,2))];
xy2=[xy2; ones(1, size(xy2,2))];

% best values
bestInlierCount = 0;
bestInliers = [];
bestErr = inf;
bestF = [];

desiredConfidence = 0.99;
nSamples = 8;

% initial iteration count (enything greater than 1 would work)
m = 3; t = 1;
while t < m
    % choose 8 random points
    rIndex = randperm(size(xy1,2));
    rIndex = rIndex(1:8);
    
    % calc the fundamental matrix
    F = fundamentalMatrix(xy1(:,rIndex),xy2(:,rIndex));
        
    % calc distances    
    for j=1:size(xy1,2)
        d(j)=distSampson( xy1(:,j), F,  xy2(:,j));
    end
    
    % find inlier indxes
    inlier_indexes = find(d < threshold);
    % compute the sum error of inliers and outliers for this F matrix
    inlierCount = size(inlier_indexes,2);
    total_count = size(xy1,2);
    Err = (sum(d(inlier_indexes)) + (total_count - inlierCount)*threshold) / total_count;  
        
    % update the best values if needed
    if(inlierCount > bestInlierCount || (inlierCount == bestInlierCount && Err < bestErr ) )
        bestInlierCount = inlierCount;
        bestErr=Err;
        bestInliers = inlier_indexes;
        bestF = F;
        
        % update max iteration count
        inlierRatio = inlierCount/size(xy1, 2);
        m=nTrials(inlierRatio,nSamples, desiredConfidence);
    end
    t = t+1;
end

% final inlier points
in1 = xy1(:, bestInliers);
in2 = xy2(:, bestInliers);

% final outlier points
out1 = xy1(:, setdiff((1:size(xy1,2)), bestInliers));
out2 = xy2(:, setdiff((1:size(xy2,2)), bestInliers));

F = bestF;
end


