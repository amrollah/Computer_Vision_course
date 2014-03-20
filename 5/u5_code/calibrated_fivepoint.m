function Evec = calibrated_fivepoint( Q1,Q2)
% Function Evec = calibrated_fivepoint( Q1,Q2)
% Henrik Stewenius 20040722
%
%
% Recent Devopments in Direct Relative Orientation
% Henrik Stewenius, Christopher Engels, David Nister 
%   
%
% Grobner Basis Methods for Minimal Problems in Computer Vision
% Henrik Stewenius, 
% PhD Thesis, Lund University, 2005
% http://www.maths.lth.se/matematiklth/personal/stewe/THESIS/ 
%
% 
% If this implementation is too slow for your needs please see: 
% An Efficient Solution to the Five-Point Relative Pose
% Da
%@Article{         nister-itpam-04,
%  author        = {Nist\'er, D.},
%  journal       = pami,
%  month         = {June},
%  number        = {6},
%  title         = {Problem},
%  pages         = {756-770},
%  volume        = {26},
%  year          = {2004}
%}
%
% 
%
%
%
%
%
%
% 5point algo, partially based on 
%  "An efficient Solution to the Five-Point Relative Pose Problem"
%
%
% Code to veryfy that it works: 
% Q1 = rand(3,5);
% Q2 = rand(3,5);
% Evec   = sm25_anvandarversion( Q1,Q2);
% for i=1:size(Evec,2)
%   E = reshape(Evec(:,i),3,3);
%   det( E)
%   2 *E*transpose(E)*E -trace( E*transpose(E))*E
% end
%

%1 Pose linear equations for the essential matrix. 
Q1 = Q1';
Q2 = Q2';

Q = [Q1(:,1).*Q2(:,1) , ...
     Q1(:,2).*Q2(:,1) , ...
     Q1(:,3).*Q2(:,1) , ... 
     Q1(:,1).*Q2(:,2) , ...
     Q1(:,2).*Q2(:,2) , ...
     Q1(:,3).*Q2(:,2) , ...
     Q1(:,1).*Q2(:,3) , ...
     Q1(:,2).*Q2(:,3) , ...
     Q1(:,3).*Q2(:,3) ] ; 


[U,S,V] = svd(Q,0);
EE = V(:,6:9);
   
A = calibrated_fivepoint_helper( EE ) ;
A = A(:,1:10)\A(:,11:20);
M = -A([1 2 3 5 6 8], :);
   
M(7,1) = 1;
M(8,2) = 1;
M(9,4) = 1;
M(10,7) = 1;

[V,D] = eig(M );
SOLS =   V(7:9,:)./(ones(3,1)*V(10,:));

Evec = EE*[SOLS ; ones(1,10 ) ]; 
Evec = Evec./ ( ones(9,1)*sqrt(sum( Evec.^2)));

I = find(not(imag( Evec(1,:) )));
Evec = Evec(:,I);