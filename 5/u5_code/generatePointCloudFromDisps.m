function coords = generatePointCloudFromDisps(disps, PL, PR, S)
    
% for each pixel (x,y) find the corresponding 3D point

coords = zeros([size(disps) 3]);

for x=1:size(disps,1)
    for y=1:size(disps,2)
        coords(x,y,1:3)= S*linTriang([x,y],[x+disps(x,y),y],PL,PR);
    end
end
