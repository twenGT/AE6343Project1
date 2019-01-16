function [ betaf, VTO, leg ] = takeOffMA( betai, TSL2WTO, WTO2S, type )

global rho_ref
global CL_Max
global a_ref
global muTO
global g

%Takeoff acceleration and rotation, kTO = 1.2
VTO = sqrt((2*betai*1.2^2)/(rho_ref*CL_Max)*WTO2S);
%Assumes CD_R - muTO*CL = 0

%Takeoff acceleration
n = 10;
VTA = linspace(0, VTO, n);
betaLeg = zeros(1,n+1);
betaLeg(1) = betai;
qTA = 1/2*rho_ref*VTA.^2;
MTA = VTA/a_ref;

for i = 2:n
    [CD, ~, ~] = dragCoeff(CL_Max, MTA(i), type);
    [~, alpha] = thrust(MTA(i), 0, 0, 2);
    xiTO = CD - muTO*CL_Max;
    u = (xiTO*qTA(i-1)/betaLeg(i-1)/WTO2S + muTO)*(betaLeg(i-1)/alpha)/TSL2WTO;
    betaLeg(i) = betaLeg(i-1)*exp(-TSFC(MTA(i), 0, 2, type)/g*(VTA(i) - VTA(i-1))/(1 - u));
end

%Takeoff rotation, t_rot = 2s
betaLeg(end) = betaLeg(end-1)*(1 - TSFC(MTA(end), 0, 2, type)*...
    alpha/betaLeg(end-1)*TSL2WTO*2);

betaf = betaLeg(end);

leg = 'Take Off';

end

