
% BAG OF WORDS RECOGNITION EXERCISE
% Alex Mansfield and Bogdan Alexe, HS 2011
%
clear;close all;clc;
codebooks = (200:20:300);
numTest = 5;
nb_acc = zeros(length(codebooks),1); %bow_recognition_nearest accuracy
by_acc = zeros(length(codebooks),1); %bow_recognition_bayes accuracy
s_index = 1;
for sizeCodebook=codebooks
    for test=1:numTest
%training
disp(strcat('creating codebook with size: ', num2str(sizeCodebook)));
% sizeCodebook = 150;
numIterations = 10;
vCenters = create_codebook('../data/cars-training-pos',sizeCodebook,numIterations);
%keyboard;
disp('processing positve training images');
vBoWPos = create_bow_histograms('../data/cars-training-pos',vCenters);
disp('processing negative training images');
vBoWNeg = create_bow_histograms('../data/cars-training-neg',vCenters);
%vBoWPos_test = vBoWPos;
%vBoWNeg_test = vBoWNeg;
%keyboard;
disp('processing positve testing images');
vBoWPos_test = create_bow_histograms('../data/cars-testing-pos',vCenters);
disp('processing negative testing images');
vBoWNeg_test = create_bow_histograms('../data/cars-testing-neg',vCenters);

nrPos = size(vBoWPos_test,1);
nrNeg = size(vBoWNeg_test,1);

test_histograms = [vBoWPos_test;vBoWNeg_test];
labels = [ones(nrPos,1);zeros(nrNeg,1)];
% save('params.mat', 'vCenters', 'test_histograms', 'labels', 'vBoWPos', 'vBoWNeg');
disp(strcat('Test ', num2str(test)));
disp('______________________________________')
disp('Nearest Neighbor classifier')
acc = bow_recognition_multi(test_histograms, labels, vBoWPos, vBoWNeg, @bow_recognition_nearest);
nb_acc(s_index) = nb_acc(s_index) + acc;
disp('______________________________________')
disp('Bayesian classifier')
acc = bow_recognition_multi(test_histograms, labels, vBoWPos, vBoWNeg, @bow_recognition_bayes);
by_acc(s_index) = by_acc(s_index) + acc;
disp('______________________________________')
clear('vCenters', 'vBoWNeg', 'vBoWPos', 'test_histograms', 'labels');
    end
    nb_acc(s_index) = nb_acc(s_index)/numTest;
    by_acc(s_index) = by_acc(s_index)/numTest;
    disp('#####################################')
    disp(strcat('Nearest Neighbor classifier (avg): ', num2str(nb_acc(s_index))))
    disp(strcat('Bayesian classifier (avg): ', num2str(by_acc(s_index))))
    s_index = s_index + 1;
end