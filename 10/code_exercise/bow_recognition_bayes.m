function label = bow_recognition_bayes( histogram, vBoWPos, vBoWNeg)


    [muPos, sigmaPos] = computeMeanStd(vBoWPos);
    [muNeg, sigmaNeg] = computeMeanStd(vBoWNeg);

    % Calculating the probability of appearance each word in observed histogram
    % according to normal distribution in each of the positive and negative bag of words
    p_hist_car = 0;
    for i=1:length(histogram),
        p = log(normpdf(histogram(i), muPos(i), sigmaPos(i)));
        if isnan(p) ~= 1
            p_hist_car = p_hist_car + p;
        end
    end;
    p_hist_car = exp(p_hist_car);
    
    p_hist_not_car = 0;
    for i=1:length(histogram),
        p = log(normpdf(histogram(i), muNeg(i), sigmaNeg(i)));
        if isnan(p) ~= 1
            p_hist_not_car = p_hist_not_car + p;
        end
    end;
    p_hist_not_car = exp(p_hist_not_car);
    
    p_car = 0.5;
    p_not_car = 0.5;
%     p_car_hist = (p_hist_car * p_car)/((p_hist_car * p_car) + (p_hist_not_car * p_not_car));
     
    if (p_hist_car * p_car) > (p_hist_not_car * p_not_car)
        label = 1;
    else
        label = 0;
    end
end