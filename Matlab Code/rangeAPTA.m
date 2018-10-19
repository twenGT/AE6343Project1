function [ range ] = rangeAPTA( WTO, S, Wfinal )

global rho_ref
global g
global CL_Max
global TSL_Mil
global muTO
global a_ref
global BCM

beta = zeros(1,10);
W = zeros(1,10);
beta(1) = 1;
W(1) = WTO;

VTO = sqrt((2*1.2^2)/(rho_ref*CL_Max)*WTO/S);

%Takeoff acceleration
n = 10;
VTA = linspace(0, VTO, n);
WTA = zeros(1,n+1);
WTA(1) = W(1);
qTA = 1/2*rho_ref*VTA.^2;
MTA = VTA/a_ref;

for i = 2:n
    [CD, ~, ~] = dragCoeff(CL_Max, MTA(i), 2);
    T = thrust(MTA(i), TSL_Mil, 0, 1);
    xiTO = CD - muTO*CL_Max;
    u = (xiTO*qTA(i-1)*S/WTA(i-1)+muTO)*WTA(i-1)/T;
    WTA(i) = WTA(i-1)*exp(-TSFC_APTA(MTA(i), 0, 1)/g*(VTA(i)-VTA(i-1))/(1-u));
end

%Takeoff rotation, t_rot = 2s
WTA(end) = WTA(end-1)*(1 - TSFC_APTA(MTA(end), 0, 1)*...
    thrust(MTA(end), TSL_Mil, 0, 1)/WTA(end-1)*2);

W(2) = WTA(end);
beta(2) = W(2)/W(1);

%2.Acclerating climb
%Assumes the 50ft obstacle is cleared at the end of take-off

n = 10;
h2a = BCA(beta(2), WTO, S);
[~, ~, ~, a2] = atmData(h2a);
V2a = BCM*a2;
VAC1 = linspace(VTO, V2a, n);
hAC1 = linspace(50, h2a, n);
WAC1 = zeros(1,n);
WAC1(1) = W(2);

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
V2b = V2a;
h2b = BCA(WAC1(end)/W(1), WTO, S);
hCC1 = linspace(h2a, h2b, n);
WCC1 = zeros(1,n);
WCC1(1) = WAC1(end);

for i = 1:n-1
    CL = liftCoeff(WCC1(i), S, hCC1(i), V2b, 1);
    [CD, ~, ~] = dragCoeff(CL, BCM, 2);
    T = thrust(BCM, TSL_Mil, hCC1(i), 1);
    u = CD/CL*WCC1(i)/T;
    WCC1(i+1) = WCC1(i)*exp(-TSFC(BCM, hCC1(i), 1)/V2b*(hCC1(i+1) - hCC1(i))/...
        (1 - u));
end

W(3) = WCC1(end);

%Max range cruise

[~, ~, ~, a] = atmData(h2b);
VCruise = BCM*a;

CL = liftCoeff(W(3), S, h2b, VCruise, 1);
[~, K1, CD0] = dragCoeff(CL, BCM, 1);

t = -1/TSFC_APTA(BCM, h2b, 3)*(sqrt(3)/(4*sqrt(CD0*K1)))*log(Wfinal/WTO);

range = t*VCruise;

end

