% Calc the number of iteration required to achiece the desiredConfidence
% with current inlierRatio and a specific number of samples (nSamples).
function [n] = nTrials(inlierRatio,nSamples,desiredConfidence)
n = log(1-desiredConfidence) / log(1-(inlierRatio)^nSamples);
end