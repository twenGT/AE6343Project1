function [ betaf, W, VTO, TSL2WTO, leg ] = takeOff( betai, WTO, S, type )

global rho_ref
global CL_Max
global TSL_Max
global a_ref
global muTO
global g
global WTO2S

%Takeoff acceleration and rotation, kTO = 1.2
VTO = sqrt((2*betai*1.2^2)/(rho_ref*CL_Max)*WTO/S);
%Assumes CD_R - muTO*CL = 0

%Takeoff acceleration
n = 10;
VTA = linspace(0, VTO, n);
WTA = zeros(1,n+1);
WTA(1) = betai*WTO;
qTA = 1/2*rho_ref*VTA.^2;
MTA = VTA/a_ref;

for i = 2:n
    [CD, ~, ~] = dragCoeff(CL_Max, MTA(i), type);
    [T, alpha] = thrust(MTA(i), TSL_Max, 0, 2);
    xiTO = CD - muTO*CL_Max;
    u = (xiTO*qTA(i-1)*S/WTA(i-1) + muTO)*WTA(i-1)/T;
    WTA(i) = WTA(i-1)*exp(-TSFC(MTA(i), 0, 2, type)/g*(VTA(i)-VTA(i-1))/(1-u));
end

%Takeoff rotation, t_rot = 2s
WTA(end) = WTA(end-1)*(1 - TSFC(MTA(end), 0, 2, type)*...
    thrust(MTA(end), TSL_Max, 0, 2)/WTA(end-1)*2);

W = WTA(end);
betaf = W/WTO;

SG = (betaf/alpha)*(WTO/TSL_Max)*(VTO^2/(2*g)); 
TSL2WTO = (betaf^2/alpha)*(1.2^2/(SG*rho_ref*g*CL_Max))*(WTO2S);

leg = 'Take Off';

end

