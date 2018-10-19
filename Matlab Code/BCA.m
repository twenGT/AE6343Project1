function [ h ] = BCA(beta, WTO, S)
%Calculates best cruise altitude

global P_ref
global T_ref
global BCM

BCM = 0.8;

B = 0.003566;   %R/ft
gRB = 5.26;

[~, K1, CD0] = dragCoeff(0, BCM, 2);
delta = 2*beta/(1.4*P_ref*BCM^2)/sqrt(CD0/K1)*WTO/S;
h = T_ref/B*(1 - delta^(1/gRB));

end

