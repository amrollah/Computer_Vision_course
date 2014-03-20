function [in1, in2, out1, out2, m, E] = ransac5pE(xy1, xy2, threshold, K)

% make points homogeneous
xy1=[xy1; ones(1, size(xy1,2))];
xy2=[xy2; ones(1, size(xy2,2))];

% best values
bestInlierCount = 0;
bestInliers = [];
bestErr = inf;
bestE = [];

desiredConfidence = 0.99;
nSamples = 8;

% initial iteration count (enything greater than 1 would work)
m = 3; t = 1;
while t < m
    % choose 5 random points
    rIndex = randperm(size(xy1,2));
    rIndex = rIndex(1:5);
    %normalize feature coordinates
    fa_n = K\xy1(:, rIndex);
    fb_n = K\xy2(:, rIndex);
    
    % calc the probable essential matrix
    Evector = calibrated_fivepoint(fa_n, fb_n);
    
    E = [];
    for i=1:size(Evector,2)
        E(:,:,i) = [ Evector(1:3, i) Evector(4:6, i) Evector(7:9, i) ]';
    end
    % now E is a 3x3xN matrix containing N essential matrices
    for ec=1:size(Evector,2)
        % calc fundamental matrix
        F=(inv(K)'*E(:,:,ec))/K;

        % calc sampson distances    
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
            bestE = E(:,:,ec);

            % update max iteration count
            inlierRatio = inlierCount/size(xy1, 2);
            m=nTrials(inlierRatio,nSamples, desiredConfidence);
        end
    end
    t = t+1;
end

% final inlier points
in1 = xy1(:, bestInliers);
in2 = xy2(:, bestInliers);

% final outlier points
out1 = xy1(:, setdiff((1:size(xy1,2)), bestInliers));
out2 = xy2(:, setdiff((1:size(xy2,2)), bestInliers));

E = bestE;
end


