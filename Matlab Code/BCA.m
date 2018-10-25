function [ h ] = BCA(beta, WTO2S)
%Calculates best cruise altitude

global P_ref
global T_ref
global BCM
global type

B = 0.003566;   %R/ft
gRB = 5.26;

[~, K1, CD0] = dragCoeff(0, BCM, type);
delta = 2*beta/(1.4*P_ref*BCM^2)/sqrt(CD0/K1)*WTO2S;
h = T_ref/B*(1 - delta^(1/gRB));

end

