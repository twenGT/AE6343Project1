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
global WpreTakeOff


beta = zeros(1,10);
W = zeros(1,10);
beta(1) = 1;
W(1) = WTO;

%1.Pre-takeoff
W(2) = W(1) - WpreTakeOff;
beta(2) = W(2)/W(1);

%2.Takeoff acceleration and rotation, kTO = 1.2
VTO = sqrt((2*beta(2)*1.2^2)/(rho_ref*CL_Max)*WTO/S);
%Assumes CD_R - muTO*CL = 0

%Takeoff acceleration
n = 100;
VTA = linspace(0, VTO, n);
WTA = zeros(1,n+2);
WTA(1) = W(2);
qTA = 1/2*rho_ref*VTA.^2;
MTA = VTA/a_ref;

for i = 1:n
    CD = dragCoeff(CL_Max, MTA(i), 1);
    u = (CD*qTA(i)/beta(2)*S/WTO)*beta(2)*WTO/TSL_Max;
    tsfc = TSFC(2, MTA(i), 0);
    WTA(i+1) = WTA(i)*exp(-tsfc/g*VTA(i)/(1-u));
end

%Takeoff rotation, t_rot = 2s
WTA(end) = WTA(end-1)*(1 - TSFC(2, MTA(end), 0)*...
                       thrust(MTA(end), TSL_Max, 0, 2)/WTA(end-1))*2;

W(3) = WTA(end);
beta(3) = W(3)/W(1);

%3.Acclerating climb
%Assumes the 50ft obstacle is cleared at the end of take-off
n = 200;
VAC = linspace(VTO, VCruise, n);
MAC = VAC/a_ref;
hAC = linspace(50, h3, n);
WAC = zeros(1,n+1);
WAC(1) = W(3);

for i = 1:n
    
    WAC(i+1) = WAC(i)*exp(-TSFC(1, MAC(i), hAC(i))/VAC(i)*...
               ((hAC(i+1) - hAC(i)) + (VAC(i+1)^2 - VAC(i)^2)/(2*g))/...
               (1 - dragCoeff(CL, MAC(i), 1)/CL*WAC(i)/thrust(MAC(i), TSL_Mil, hAC(i), 1)));
    
end






end

