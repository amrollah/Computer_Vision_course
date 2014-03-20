function particles_w = observe(particles,frame,HeightBB,WidthBB,nBins,hist_target,sigma_observe)

numParticles = size(particles,1);
particles_w = zeros(numParticles,1);
for i=1:numParticles
    P_hist = color_histogram(particles(i,1)-0.5*WidthBB,particles(i,2)-0.5*HeightBB,particles(i,1)+0.5*WidthBB,particles(i,2)+0.5*HeightBB,frame,nBins);
    dist = chi2_cost(P_hist, hist_target);
    particles_w(i,1) = (1/(sqrt(2*pi)*sigma_observe))*exp(-dist/2*sigma_observe^2);
end
totalw=sum(particles_w);
particles_w(:)=particles_w(:)./totalw;
end