function [ WFinal, beta ] = missionAnalysisAPTA( WTO, S )
%|1|Pre-takeoff|2|Takeoff acceleration|3|Acclerating climb|4|Cruise
%|5|Rendezvous|6|Refueling Sim|7|Accelerating climb|8|Cruise|9|Descend
%|10|Combat training|11|Cruise climb|12|Cruise|13|Landing|14|Reserve

%Assumes future drag polar, BCM = 0.8;


global rho_ref
global g
global CL_Max
global TSL_Mil
global a_ref
global BCM

global WpreTakeOff

beta = zeros(1,15);
W = zeros(1,15);
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

%Military thrust take-off due to higher CL
for i = 2:n
    [CD, ~, ~] = dragCoeff(CL_Max, MTA(i), 2);
    T = thrust(MTA(i), TSL_Mil, 0, 1);
    u = CD*qTA(i)*S/T;
    WTA(i) = WTA(i-1)*exp(-TSFC(MTA(i), 0, 1)/g*(VTA(i)-VTA(i-1))/(1-u));
end

%Takeoff rotation, t_rot = 2s
WTA(end) = WTA(end-1)*(1 - TSFC(MTA(end), 0, 1)*...
    thrust(MTA(end), TSL_Mil, 0, 1)/WTA(end-1)*2);

W(3) = WTA(end);
beta(3) = W(3)/W(1);

%3.Acclerating climb
%Assumes the 50ft obstacle is cleared at the end of take-off

n = 10;
h3a = BCA(beta(3), WTO, S);
[~, ~, ~, a3] = atmData(h3a);
V3a = BCM*a3;
VAC1 = linspace(VTO, V3a, n);
hAC1 = linspace(50, h3a, n);
WAC1 = zeros(1,n);
WAC1(1) = W(3);

for i = 1:n-1
    [~, ~, ~, a] = atmData(hAC1(i));
    MAC = VAC1(i)/a;
    CL = liftCoeff(WAC1(i), S, hAC1(i), VAC1(i), 1);
    [CD, ~, ~] = dragCoeff(CL, MAC, 2);
    T = thrust(MAC, TSL_Mil, hAC1(i), 1);
    u = CD/CL*WAC1(i)/T;
    WAC1(i+1) = WAC1(i)*exp(-TSFC(MAC, hAC1(i), 1)/VAC1(i)*...
        ((hAC1(i+1) - hAC1(i)) + (VAC1(i+1)^2 - VAC1(i)^2)/(2*g))/(1 - u));
end

%BCA has changed due to new beta. Perform one cruise climb correction

n = 10;
V3b = V3a;
h3b = BCA(WAC1(end)/W(1), WTO, S);
hCC1 = linspace(h3a, h3b, n);
WCC1 = zeros(1,n);
WCC1(1) = WAC1(end);

for i = 1:n-1
    CL = liftCoeff(WCC1(i), S, hCC1(i), V3b, 1);
    [CD, ~, ~] = dragCoeff(CL, BCM, 2);
    T = thrust(BCM, TSL_Mil, hCC1(i), 1);
    u = CD/CL*WCC1(i)/T;
    WCC1(i+1) = WCC1(i)*exp(-TSFC(BCM, hCC1(i), 1)/V3b*(hCC1(i+1) - hCC1(i))/...
        (1 - u));
end

W(4) = WCC1(end);
beta(4) = W(4)/W(1);

%4.Cruise
%At BCM/BCA for 150nm

n = 10;
hCr1 = h3b;
WCr1 = zeros(1,n+1);
WCr1(1) = W(4);
%150 nautical miles
dt = 150*6076.115/V3b/n;

for i = 1:n
    CL = liftCoeff(WCr1(i), S, hCr1, V3b, 1);
    [CD, ~, ~] = dragCoeff(CL, BCM, 2);
    WCr1(i+1) = WCr1(i)*exp(-TSFC(BCM, hCr1, 3)*CD/CL*dt);
end

W(5) = WCr1(end);
beta(5) = W(5)/W(1);

%5.Rendezvous
%20000ft and 300knots for 100nm

n = 10;
hR = 20000;
WR = zeros(1,n+1);
WR(1) = W(5);
V5 = 300*1.688;
%100 nautical miles
dt = 100*6076.115/V5/n;

for i = 1:n
    CL = liftCoeff(WR(i), S, hR, V5, 1);
    [CD, ~, ~] = dragCoeff(CL, BCM, 2);
    WR(i+1) = WR(i)*exp(-TSFC(BCM, hR, 3)*CD/CL*dt);
end

W(6) = WR(end);
beta(6) = W(6)/W(1);

%6.Refueling simulation
%20000ft and 250knots for 20 min

n = 10;
hRS = 20000;
WRS = zeros(1,n+1);
WRS(1) = W(6);
V6 = 250*1.688;
%100 nautical miles
dt = 20*60/n;

for i = 1:n
    CL = liftCoeff(WRS(i), S, hRS, V6, 1);
    [CD, ~, ~] = dragCoeff(CL, BCM, 2);
    WRS(i+1) = WRS(i)*exp(-TSFC(BCM, hRS, 3)*CD/CL*dt);
end

W(7) = WRS(end);
beta(7) = W(7)/W(1);


%7.Acclerating climb
%Climbs to BCA at BCM

n = 10;
h7 = BCA(beta(7), WTO, S);
[~, ~, ~, a7] = atmData(h7);
V7 = BCM*a7;
VAC2 = linspace(V6, V7, n);
hAC2 = linspace(hRS, h7, n);
WAC2 = zeros(1,n);
WAC2(1) = W(7);

for i = 1:n-1
    [~, ~, ~, a] = atmData(hAC2(i));
    MAC = VAC2(i)/a;
    CL = liftCoeff(WAC2(i), S, hAC2(i), VAC2(i), 1);
    [CD, ~, ~] = dragCoeff(CL, MAC, 2);
    T = thrust(MAC, TSL_Mil, hAC2(i), 1);
    u = CD/CL*WAC2(i)/T;
    WAC2(i+1) = WAC2(i)*exp(-TSFC(MAC, hAC2(i), 1)/VAC2(i)*...
        ((hAC2(i+1) - hAC2(i)) + (VAC2(i+1)^2 - VAC2(i)^2)/(2*g))/(1 - u));
end

W(8) = WAC2(end);
beta(8) = W(8)/W(1);

%8.Cruise
%At BCM/BCA for 100nm

n = 10;
hCr2 = h7;
WCr2 = zeros(1,n+1);
WCr2(1) = W(8);
dt = 100*6076.115/V7/n;

for i = 1:n
    CL = liftCoeff(WCr2(i), S, hCr2, V7, 1);
    [CD, ~, ~] = dragCoeff(CL, BCM, 2);
    WCr2(i+1) = WCr2(i)*exp(-TSFC(BCM, hCr2, 3)*CD/CL*dt);
end

W(9) = WCr2(end);
beta(9) = W(9)/W(1);

%9.Descend
%Decending consumes approximately no fuel

W(10) = W(9);
beta(10) = beta(9);

%10.Combat training
%Load factor = 8 for 20min at 15000ft
n = 10;
hCT = 15000;
[~, ~, ~, a10] = atmData(hCT);
VCT = BCM*a10;
WCT = zeros(1,n+1);
WCT(1) = W(10);
dt = 20*60/n;

for i = 1:n
    CL = liftCoeff(WCT(i), S, hCT, VCT, 8);
    [CD, ~, ~] = dragCoeff(CL, BCM, 2);
    WCT(i+1) = WCT(i)*exp(-TSFC(BCM, hCT, 3)*CD/CL*dt);
end

W(11) = WCT(end);
beta(11) = W(11)/W(1);

%11.Acclerating climb
%Climbs to BCA at BCM

n = 10;
h11 = BCA(beta(11), WTO, S);
[~, ~, ~, a11] = atmData(h11);
V11 = BCM*a11;
VAC3 = linspace(VCT, V11, n);
hAC3 = linspace(hCT, h11, n);
WAC3 = zeros(1,n);
WAC3(1) = W(11);

for i = 1:n-1
    [~, ~, ~, a] = atmData(hAC3(i));
    MAC = VAC3(i)/a;
    CL = liftCoeff(WAC3(i), S, hAC3(i), VAC3(i), 1);
    [CD, ~, ~] = dragCoeff(CL, MAC, 2);
    T = thrust(MAC, TSL_Mil, hAC3(i), 1);
    u = CD/CL*WAC3(i)/T;
    WAC3(i+1) = WAC3(i)*exp(-TSFC(MAC, hAC3(i), 1)/VAC3(i)*...
        ((hAC3(i+1) - hAC3(i)) + (VAC3(i+1)^2 - VAC3(i)^2)/(2*g))/(1 - u));
end

W(12) = WAC3(end);
beta(12) = W(12)/W(1);

%12.Cruise
%At BCM/BCA for 150nm

n = 10;
hCr3 = h11;
WCr3 = zeros(1,n+1);
WCr3(1) = W(12);
dt = 150*6076.115/V11/n;

for i = 1:n
    CL = liftCoeff(WCr3(i), S, hCr3, V11, 1);
    [CD, ~, ~] = dragCoeff(CL, BCM, 2);
    WCr3(i+1) = WCr3(i)*exp(-TSFC(BCM, hCr3, 3)*CD/CL*dt);
end

W(13) = WCr3(end);
beta(13) = W(13)/W(1);

%13.Landing
%Landing consumes approximately no fuel

W(14) = W(13);
beta(14) = beta(13);

%14.Reserve
%At BCM/BCA for 30min at 10000ft

n = 10;
hRes = 10000;
WRes = zeros(1,n+1);
WRes(1) = W(14);
[~, ~, ~, a14] = atmData(hRes);
V14 = BCM*a14;
dt = 30*60/n;

for i = 1:n
    CL = liftCoeff(WRes(i), S, hRes, V14, 1);
    [CD, ~, ~] = dragCoeff(CL, BCM, 2);
    WRes(i+1) = WRes(i)*exp(-TSFC(BCM, hRes, 3)*CD/CL*dt);
end

W(15) = WRes(end);
beta(15) = W(15)/W(1);



end

