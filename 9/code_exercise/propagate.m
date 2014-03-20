function new_particles = propagate(particles,sizeFrame,params)
if params.model==1
    A = [[1,0]',[0,1]',[1,0]',[0,1]']; % constant velocity
else
    A = [1 0;0 1]; % just noise
end
new_particles = zeros(params.num_particles,size(particles(1,:),2));
i = 1;
while i <= params.num_particles
    noise_pos = normrnd(0,params.sigma_position,[1 2]);
    
    new_particles(i,1:2) = floor((A*particles(i,:)')' + noise_pos);
    if (new_particles(i,1) < sizeFrame(2) && new_particles(i,1) > 0 && new_particles(i,2) < sizeFrame(1) && new_particles(i,2) > 0)
        if (params.model==1)
            noise_velocity = normrnd(0,params.sigma_velocity,[1 2]);
%             new_particles(i,3:4) = particles(i,3:4) + noise_velocity;
            new_particles(i,3:4) = params.initial_velocity + noise_velocity;
        end
        i = i + 1;
    end
end
end