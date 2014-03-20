function vPoints = grid_points(img,nPointsX,nPointsY,border)
    h = size(img, 1);
    w = size(img, 2);
    
    stepY = floor((w-2*border-1)/(nPointsY-1));
    stepX = floor((h-2*border-1)/(nPointsX-1));
%     meshgrid(border+1:stepX:w-border,border+1:stepY:h-border);
    y = (border+1:stepY:w-border);
    x = (border+1:stepX:h-border);
    
    vPoints = zeros(nPointsX*nPointsX,2);
    ct = 1;
    for i=(1:nPointsX)
        for j=(1:nPointsY)
           vPoints(ct,:) = [x(i) y(j)];
           ct = ct + 1;
        end
    end
%     disp(vPoints);
end
