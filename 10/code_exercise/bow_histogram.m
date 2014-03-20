function histo = bow_histogram(vFeatures, vCenters)
  % input:
  %   vFeatures: MxD matrix containing M feature vectors of dim. D
  %   vCenters : NxD matrix containing N cluster centers of dim. D
  % output:
  %   histo    : N-dim. vector containing the resulting BoW
  %              activation histogram.
  
  
  % Match all features to the codebook and record the activated
  % codebook entries in the activation histogram "histo".
  sizeCodebook = size(vCenters,1);
  histo = zeros(sizeCodebook,1);
  % assign all features to its nearest center
  [idx,~] = findnn(vFeatures,vCenters);
  
  % for each center
  for i = 1:sizeCodebook
    % count matching features
    histo(i)=length(find(idx==i));
  end
 
end
