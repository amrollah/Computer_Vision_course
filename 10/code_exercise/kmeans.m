function vCenters = kmeans(vFeatures,k,numiter)

  nPoints  = size(vFeatures,1);
  nDims    = size(vFeatures,2);
  vCenters = zeros(k,nDims);

  % Initialize each cluster center to a different random point.
  r_index = randperm(nPoints);
  vCenters = vFeatures(r_index(1:k),:);
  
  % Repeat for numiter iterations
  for i=1:numiter,
    % Assign each point to the closest cluster
    [Idx Dist] = findnn(vFeatures, vCenters);
    

    % Shift each cluster center to the mean of its assigned points
    for t=1:k,
        vCenters(t,:) = mean(vFeatures(find(Idx==t),:));
    end;
    
    disp(strcat(num2str(i),'/',num2str(numiter),' iterations completed.'));
  end;
 
 
end
