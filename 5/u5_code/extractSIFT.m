function [frames, descr] = extractSIFT(img)
    img = img - min(img(:)) ;
    img = img/max(img(:)) ;

    [frames, descr] = sift(img);
    a = 1;
end