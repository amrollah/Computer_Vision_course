function [map, peak] = meanshiftSeg(img)
[row col v] = size(img);
X = double(reshape(img,[row*col v]));
r = 35;
[map, peak] = mean_shift(X, r);
map = reshape(map,row,col);
end

function [map, peaks] = mean_shift(X, r)
numPts = size(X,1);
VisitedPts = zeros(1,numPts);
availPtsCnt = numPts;
AvailPts = 1:numPts;
clusterVotes = zeros(1,numPts);
clustCent = [];
numClust = 0;
while availPtsCnt > 0
    ind = AvailPts(ceil(availPtsCnt*rand));  
    
    [peak, clusterPts, currClusterVts] = find_peak(X, X(ind,:), r);
    VisitedPts(clusterPts) = 1;
    
    mergeCandid = 0;
    for clst = 1:numClust
        distToOther = norm(peak-clustCent(clst));
        if distToOther < r/2 
            mergeCandid = clst;
            break;
        end
    end

    if mergeCandid > 0 
        clustCent(mergeCandid,:) = (peak+clustCent(mergeCandid))/2;             
        clusterVotes(mergeCandid,:) = clusterVotes(mergeCandid,:) + currClusterVts;
        disp('meged');
    else 
        numClust = numClust+1;                 
        clustCent(numClust,:) = peak;                        
        clusterVotes(numClust,:) = currClusterVts;
    end
                
    AvailPts = find(VisitedPts == 0);
    availPtsCnt = length(AvailPts);
end
[~,map] = max(clusterVotes,[],1);
peaks = clustCent;
end

function [peak, clusterPts, currClusterVts]  = find_peak(X, xl , r)
numPts = size(X,1);
peak = xl;
currClusterVts = zeros(1, numPts);
clusterPts= [];
while 1
    diffToAll = sum((repmat(peak,numPts, 1) - X).^2, 2);  %./ repmat(peak,numPts, 1)
    ptsInWindow = find(diffToAll < r^2);               
    oldMean = peak;
    peak      = mean(X(ptsInWindow,:),1);
    clusterPts = [clusterPts ptsInWindow'];
    currClusterVts(ptsInWindow) = currClusterVts(ptsInWindow)+1;
    if norm(peak - oldMean) < .01*r   %/norm(peak)
        break; 
    end
end        
end