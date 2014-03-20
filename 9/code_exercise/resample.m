function [particles, particles_w] = resample(particles,particles_w)
n = size(particles,1);
idxs = randsample(n,n,true,particles_w);
particles = particles(idxs,:);
particles_w = particles_w(idxs);
% rescale new particle weights to sum equals 1
totalw=sum(particles_w);
particles_w(:)=particles_w(:)./totalw;
end