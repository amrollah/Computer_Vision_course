% Generate initial values for the cov
% covariance matrices

function cov = generate_cov(X, K)
rng = range(X);
c = diag(rng);
for k=1:K
    cov(k,:,:) = c;
end

end