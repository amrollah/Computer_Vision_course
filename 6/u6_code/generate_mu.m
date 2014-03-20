% Generate initial values for mu
% K is the number of segments

function mu = generate_mu(X, K)
numPts = size(X,1);
mu = X(randi(numPts,K,1),:)';

end