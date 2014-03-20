function [map cluster] = EM(img, K)
[row col v] = size(img);
N = row*col;
X = double(reshape(img,[N v]));

% use function generate_mu to initialize mus
mu = generate_mu(X, K);

% use function generate_cov to initialize covariances
cov = generate_cov(X, K);

alpha=ones(K,1)/K;

% iterate between maximization and expectation
mu0=mu*0;
cov0=0*cov;
alpha0=alpha*0;
p0=ones(N,K);
energy=sum(sum((mu-mu0).^2))+sum(sum((cov-cov0).^2))+(sum((alpha-alpha0).^2));
iter=0;
% while energy>10^(-6)
while 1
    P = expectation(mu,cov,alpha,X);
    
    [mu, cov, alpha] = maximization(P, X);

    iter = iter + 1;
%     energy=sum(sum((mu-mu0).^2))+sum(sum(sum((cov-cov0).^2)))+(sum((alpha-alpha0).^2));
    energy = norm(sum((P-p0).^2));
    fprintf('iter = %d \n', iter);
    fprintf('energy = %f \n',energy);
    
    if energy<.05
        break;
    end
    p0 = P;
    mu0 = mu;
    cov0=cov;
    alpha0=alpha;
end

[~,MxInd] = max(P,[],2);  
map = reshape(MxInd,row,col);
cluster = mu;
end