% match descriptors
%
% Input:
%   descr1        - k x n descriptor of first image
%   descr2        - k x m descriptor of second image
%   thresh        - scalar value to threshold the matches
%   
% Output:
%   matches       - 2 x w matrix storing the indices of the matching
%                   descriptors
function matches = matchDescriptors(descr1, descr2, thresh)   
    matches=[];
    
    for i=1:size(descr1,1)
        sdd=[];
        for j=1:size(descr2,1)
            c_sdd = sum((descr2(j,:)-descr1(i,:)).^2);
            if(c_sdd <= thresh)
                sdd = [c_sdd, j; sdd];
            end
        end
        if (size(sdd,1) >= 1)
            [v ind]=min(sdd(:,1));
            matches=[[i sdd(ind, 2)]', matches];
        end
    end
end