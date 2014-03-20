function sLabel = bow_recognition_nearest(histogram,vBoWPos,vBoWNeg)
  
 % Find the nearest neighbor in the positive and negative sets
 % and decide based on this neighbor
  [~, DistPos] = findnn(histogram, vBoWPos);
  [~, DistNeg] = findnn(histogram, vBoWNeg);
  
  if (DistPos<DistNeg)
    sLabel = 1;
  else
    sLabel = 0;
  end
  
end
