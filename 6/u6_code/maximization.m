function [mu, cov, alpha] = maximization(P, X)

K = size(P,2);
N = size(X,1);
dim = size(X,2);

alpha = (sum(P) ./ N)';
mu = zeros(K, dim);
for k=1:K
    mu(k,:) = sum(X(1:N,:) .* repmat(P(:,k),1,dim)) ./ sum(P(:,k));
end
mu = mu';

for k=1:K
    sum1 = zeros(dim,dim);
    for n=1:N
        sum1 = sum1 + P(n,k) .* ((X(n,:)' - mu(:,k)) * (X(n,:)' - mu(:,k))');
    end
    cov(k,:,:) = sum1 ./ sum(P(:,k));
end

end