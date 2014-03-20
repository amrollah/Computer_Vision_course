function [ K, R, C ] = decompose(P)
    %decompose P into K, R and t
    % Convenience variables for the columns of P
    p1 = P(:,1);
    p2 = P(:,2);
    p3 = P(:,3);    

    M = [p1 p2 p3];
    
    C = null(P,'r');
    
    % Perform RQ decomposition of M matrix. Note that rq3 returns K with +ve
    % diagonal elements, as required for the calibration marix.
    
    [R1 K1] = qr(inv(M));
    K = inv(K1);
    K=K./K(3,3);
    R = inv(R1);    
    %[K R] = qr(M);
end