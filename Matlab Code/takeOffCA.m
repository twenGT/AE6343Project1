function [ VTO, TSL2WTO, leg ] = takeOffCA( beta )

global rho_ref
global CL_Max
global g
global WTO2S

%Takeoff acceleration and rotation, kTO = 1.2
VTO = sqrt((2*beta*1.2^2)/(rho_ref*CL_Max)*WTO2S);
%Assumes CD_R - muTO*CL = 0

alpha = 0.955;
%SG = (beta/alpha)*(WTO/TSL_Max)*(VTO^2/(2*g));
SG = 2500;
TSL2WTO = (beta^2/alpha)*(1.2^2/(SG*rho_ref*g*CL_Max))*(WTO2S);

leg = 'Take Off';

end

