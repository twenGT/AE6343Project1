function [WFinal, beta] = missionAnalysisF86L(WTO, S)
%|1|Pre-takeoff|2|Takeoff acceleration|3|Acclerating climb|4|Cruise climb
%|5|Loiter|6|Cruise climb|7|Combat|8|Cruise|9|Loiter|10|Landing

global rho_ref
global g
global CL_Max
global TSL_Max
global TSL_Mil
global a_ref
global muTO

global VCruise
global VCombat
global WpreTakeOff
global h3
global h4
global h6
global h8

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
n = 10;
VTA = linspace(0, VTO, n);
WTA = zeros(1,n+1);
WTA(1) = W(2);
qTA = 1/2*rho_ref*VTA.^2;
MTA = VTA/a_ref;

for i = 2:n
    [CD, ~, ~] = dragCoeff(CL_Max, MTA(i), 1);
    T = thrust(MTA(i), TSL_Max, 0, 2);
    xiTO = CD - muTO*CL_Max;
    u = (xiTO*qTA(i-1)*S/WTA(i-1)+muTO)*WTA(i-1)/T;
    WTA(i) = WTA(i-1)*exp(-TSFC_F86L(MTA(i), 0, 2)/g*(VTA(i)-VTA(i-1))/(1-u));
end

%Takeoff rotation, t_rot = 2s
WTA(end) = WTA(end-1)*(1 - TSFC_F86L(MTA(end), 0, 2)*...
    thrust(MTA(end), TSL_Max, 0, 2)/WTA(end-1)*2);

W(3) = WTA(end);
beta(3) = W(3)/W(1);

%3.Acclerating climb
%Assumes the 50ft obstacle is cleared at the end of take-off
n = 10;
VAC1 = linspace(VTO, VCruise, n);
hAC1 = linspace(50, h3, n);
WAC1 = zeros(1,n);
WAC1(1) = W(3);

for i = 1:n-1
    [~, ~, ~, a] = atmData(hAC1(i));
    MAC = VAC1(i)/a;
    CL = liftCoeff(WAC1(i), S, hAC1(i), VAC1(i), 1);
    [CD, ~, ~] = dragCoeff(CL, MAC, 1);
    T = thrust(MAC, TSL_Mil, hAC1(i), 1);
    u = CD/CL*WAC1(i)/T;
    WAC1(i+1) = WAC1(i)*exp(-TSFC_F86L(MAC, hAC1(i), 1)/VAC1(i)*...
        ((hAC1(i+1) - hAC1(i)) + (VAC1(i+1)^2 - VAC1(i)^2)/(2*g))/(1 - u));
end

W(4) = WAC1(end);
beta(4) = W(4)/W(1);

%4.Cruise climb
%altitude change
n = 10;
hCC1a = linspace(h3, h4, n);
WCC1a = zeros(1,n);
WCC1a(1) = W(4);

for i = 1:n-1
    [~, ~, ~, a] = atmData(hCC1a(i));
    MCC1a = VCruise/a;
    CL = liftCoeff(WCC1a(i), S, hCC1a(i), VCruise, 1);
    [CD, ~, ~] = dragCoeff(CL, MCC1a, 1);
    T = thrust(MCC1a, TSL_Mil*1.1, hCC1a(i), 1);
    u = CD/CL*WCC1a(i)/T;
    WCC1a(i+1) = WCC1a(i)*exp(-TSFC_F86L(MCC1a, hCC1a(i), 1)/VCruise*(hCC1a(i+1) - hCC1a(i))/...
        (1 - u));
end

%cruise
n = 10;
hCC1b = h4;
WCC1b = zeros(1,n+1);
WCC1b(1) = WCC1a(end);
%550 nautical miles
dt = 550*6076.115/VCruise/n;

[~, ~, ~, a] = atmData(hCC1b);
MCC1b = VCruise/a;

for i = 1:n
    CL = liftCoeff(WCC1b(i), S, hCC1b, VCruise, 1);
    [CD, ~, ~] = dragCoeff(CL, MCC1b, 1);
    WCC1b(i+1) = WCC1b(i)*exp(-TSFC_F86L(MCC1b, hCC1b, 3)*CD/CL*dt);
end

W(5) = WCC1b(end);
beta(5) = W(5)/W(1);

%5.Loiter
%for 10 min
n = 10;
hL1 = h4;
WL1 = zeros(1,n+1);
WL1(1) = W(5);
dt = 10*60/n;

[~, ~, ~, a] = atmData(hL1);
ML1 = VCruise/a;
CL = liftCoeff( W(5), S, hL1, VCruise, 1 );
[~, CD0K1] = dragCoeff(CL, ML1, 1);

for i = 1:n
    WL1(i+1) = WL1(i)*exp(-TSFC_F86L(ML1, hL1, 4)*sqrt(4*CD0K1)*dt);
end

W(6) = WL1(end);
beta(6) = W(6)/W(1);

%6.Acclerating climb
%Assumes military power
n = 10;
VAC2 = linspace(VCruise, VCruise, n);
%VAC2 = linspace(VCruise, VCombat, n);
hAC2 = linspace(h4, h6, n);
WAC2 = zeros(1,n);
WAC2(1) = W(6);

for i = 1:n-1
    [~, ~, ~, a] = atmData(hAC2(i));
    MAC = VAC2(i)/a;
    CL = liftCoeff(WAC2(i), S, hAC2(i), VAC2(i), 1);
    [CD, ~, ~] = dragCoeff(CL, MAC, 1);
    T = thrust(MAC, TSL_Mil*1.2, hAC2(i), 1);
    u = CD/CL*WAC2(i)/T;
    WAC2(i+1) = WAC2(i)*exp(-TSFC_F86L(MAC, hAC2(i), 1)/VAC2(i)*...
        (hAC2(i+1) - hAC2(i))/(1 - u));
%        ((hAC2(i+1) - hAC2(i)) + (VAC2(i+1)^2 - VAC2(i)^2)/(2*g))/(1 - u));
end

W(7) = WAC2(end);
beta(7) = W(7)/W(1);

%7.Combat
%for 5 min
n = 10;
hCb = h6;
WCb = zeros(1,n+1);
WCb(1) = W(7);
dt = 5*60/n;

[~, ~, ~, a] = atmData(hCb);
MCb = VCombat/a;

for i = 1:n
    CL = liftCoeff(WCb(i), S, hCb, VCombat, 1);
    [CD, ~, ~] = dragCoeff(CL, MCb, 1);
    WCb(i+1) = WCb(i)*exp(-TSFC_F86L(MCb, hCb, 2)*CD/CL*dt);
end

W(8) = WCb(end);
beta(8) = W(8)/W(1);

%8.Cruise
n = 10;
hCr = h8;
WCr = zeros(1,n+1);
WCr(1) = W(8);
%550 nautical miles
dt = 550*6076.115/VCruise/n;

[~, ~, ~, a] = atmData(hCr);
MCr = VCruise/a;

for i = 1:n
    CL = liftCoeff(WCr(i), S, hCr, VCruise, 1);
    [CD, ~, ~] = dragCoeff(CL, MCr, 1);
    WCr(i+1) = WCr(i)*exp(-TSFC_F86L(MCr, hCr, 3)*CD/CL*dt);
end

W(9) = WCr(end);
beta(9) = W(9)/W(1);


%9.Loiter
%for 10 min
n = 10;
hL2 = h4;
WL2 = zeros(1,n+1);
WL2(1) = W(9);
dt = 10*60/n;

[~, ~, ~, a] = atmData(hL2);
ML2 = VCruise/a;
CL = liftCoeff( W(9), S, hL2, VCruise, 1 );
[~, CD0K1] = dragCoeff(CL, ML2, 1);

for i = 1:n
    WL2(i+1) = WL2(i)*exp(-TSFC_F86L(ML2, hL2, 4)*sqrt(4*CD0K1)*dt);
end

W(10) = WL2(end);
beta(10) = W(10)/W(1);

%10.Landing
%MATTINGLY, descent and landing require minimal fuel,
%beta stays the same

WFinal = W(10);

end

