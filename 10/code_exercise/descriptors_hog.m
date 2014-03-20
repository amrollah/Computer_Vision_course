function [descriptors,patches] = descriptors_hog(img,vPoints,cellWidth,cellHeight)

    nBins = 8;
    w = cellWidth; % set cell dimensions
    h = cellHeight;   
    NumCells = 4;
    
    nPoints = size(vPoints,1);
    descriptors = zeros(nPoints,nBins*4*4); % one histogram for each of the 16 cells
    patches = zeros(nPoints,4*w*4*h); % image patches stored in rows    
    
    [grad_x,grad_y]=gradient(img);
    angles = atan2(grad_y, grad_x);
    magnit = ((grad_y.^2) + (grad_x.^2)).^.5;
    
    for i = (1:nPoints) % for all local feature points
        topCorner = vPoints(i,:)-[(NumCells/2)*w, (NumCells/2)*h];
%         disp(topCorner);
        for cx = (0:NumCells-1)
            rowOffset = topCorner(1) + (cx * w);
            for cy = (0:NumCells-1)        
                colOffset = topCorner(2) + (cy * h);
                rowIndeces = rowOffset : (rowOffset + w - 1);
                colIndeces = colOffset : (colOffset + h - 1);
%                 disp('row: ');
%                 disp(rowIndeces);
%                 disp('col: ');
%                 disp(colIndeces);
                cellAngles = angles(rowIndeces, colIndeces); 
                cellMagnitudes = magnit(rowIndeces, colIndeces);
                
                cellHOGs(cx + 1, cy + 1, :) = cellHistogram(cellMagnitudes(:), cellAngles(:), nBins);
            end
        end
        descriptors(i,:) = cellHOGs(:);
        patch = img(topCorner(1):(topCorner(1) + (NumCells * w -1)),topCorner(2):(topCorner(2) + (NumCells * h -1)));
        patches(i,:) = patch(:);
% disp(size(patches));
    end
    
end
