function [in1, in2, out1, out2, m, E] = ransac5pE(xy1, xy2, threshold, K)



end


%% =========================================================================

% sample script for 5-point algorithm:

%load camera calibration
K = [130.5024      0  500.0005
         0  130.5024  372.3164
         0         0    1.0000];
%normalize feature coordinates
fa_n = inv(K)*[fa(1:2, matches(1,:));ones(1,length(matches))];
fb_n = inv(K)*[fb(1:2, matches(2,:));ones(1,length(matches))];

%the following function computes up to 10 (typically 4-6) essential matrix
%solutions for the given point-correspondences (they have to be 
%calibrated/normalized with the intrinsic camera calibration!)

%you will need the compiled mex-file for that to run, for Windows 32 and
%64-bit the binary is already included, for Mac and Linux, just type
% mex calibrated_fivepoint_helper
%and the C code will be compiled to a MATLAB compatible binary. If you have
%problems, you can try to reconfigure the build environment: mex -setup
Evector = calibrated_fivepoint(fa_n, fb_n)

E = [];
for i=1:size(Evector,2)
    E(:,:,i) = [ Evector(1:3, i) Evector(4:6, i) Evector(7:9, i) ]';
end

% now E is a 3x3xN matrix containing N essential matrices
E
