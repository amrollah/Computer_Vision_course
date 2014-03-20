function f = fminGoldStandardRadial(p, xy, XYZ, w)

%reassemble P
P = [p(1:4);p(5:8);p(9:12)];

%compute squared geometric error with radial distortion

%compute cost function value
f = 0;
end