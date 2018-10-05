function [ WFinal ] = missionAnalysis( WTO, S )
%UNTITLED2 Summary of this function goes here
%|1|Pre-takeoff|2|Takeoff acceleration|3|

global rho_ref
global CL_Max
global C_maxPower

beta = zeros(1,10);
W = zeros(1,10);
beta(1) = 1;
W(1) = WTO;

%1.Pre-takeoff
W(2) = W(1) - WpreTakeOff;
beta(2) = W(2)/W(1);

%2.Takeoff acceleration
VTO = sqrt((2*beta(1)*1.2^2)/(rho_ref*CL_Max)*(WTO)/S);
%Assumes CD_R - muTO*CL = 0
CD = dragCoeff(CL_Max, 0, 1);
%Assumes qAvg = 1/2*qTO
q = 1/2*rho_ref*(VTO)^2/2;
u = (CD*q/beta(1)*S/WTO)*beta(1)*WTO/TSL_Max;
W32 = exp(-C_maxPower/9.8*VTO/(1-u));
W(3) = W32*W(2);
beta(3) = W(3)/W(1);






end

