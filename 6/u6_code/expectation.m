function P = expectation(mu,var,alpha,X)

K = length(alpha);
N = size(X,1);
P = zeros(K,N);

expect = zeros(K,N);
for k=1:K
    gm = GMM(X,mu(:,k),var(k,:,:));
    dc =  gm .* alpha(k);
    expect(k,:) = dc';
end
SumOverK = sum(expect);
for k=1:K
    P(k,:) = expect(k,:) ./ SumOverK;
end
P = P';
end

function gmm=GMM(X,mu,cov)
N = size(X,1);
dim = size(X,2);
cov = reshape(cov,dim,dim);

for i=1:N
    gmm(i) =  ((((2*pi)^(dim * 0.5))* sqrt(det(cov)))^(-1)) .* exp(-0.5 * ((X(i,:)'-mu)' / cov) *(X(i,:)'-mu));
end

end