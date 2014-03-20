function meanState = estimate(particles, particles_w)
state_length = size(particles(1,:),2);
for i=1:state_length
    meanState(i) = sum(particles(:,i).*particles_w);
end
end