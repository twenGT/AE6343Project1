function [WFinal] = missionAnalysisF86L(WTO, S)
%UNTITLED2 Summary of this function goes here
%|1|Pre-takeoff|2|Takeoff acceleration|3|Acclerating climb|4|Cruise climb
%|5|

global rho_ref
global g
global CL_Max
global TSL_Max
global a_ref


global VCruise

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

n = 100;
V = linspace(0, VTO, n);
WTA = zeros(1,n+1);
WTA(1) = W(2);

q = 1/2*rho_ref*V.^2;
u = (CD*q/beta(2)*S/WTO)*beta(2)*WTO/TSL_Max;

for i = 1:n
    M = V(i)/a_ref;
    tsfc = TSFC(2, M, 0);
    WTA(i) = exp(-tsfc/g*V(i)/(1-u));
end
W(3) = W32*W(2);
beta(3) = W(3)/W(1);

%3.Acclerating climb
n = 100;
V = linspace(VTO, VCruise, n);
h = linspace(0, h3, n);

WAC = zeros(1,n+1);
WAC(1) = W(3);

for i = 1:100
    
    [T, ~, ~] = atmData(h(i));
    theta = sqrt(T/T)
    WAC(i+1) = WAC(i)*exp(-C_milPower*);
    
end






end

