function [ betaf, W ] = cruiseClimb( betai, WTO, S, hi, hf, type )
%Range unit in nautical miles

global VCruise
global TSL_Mil

%altitude change
n = 10;
hCC = linspace(hi, hf, n);
WCC = zeros(1,n);
WCC(1) = betai*WTO;

for i = 1:n-1
    [~, ~, ~, a] = atmData(hCC(i));
    MCC1a = VCruise/a;
    CL = liftCoeff(WCC(i), S, hCC(i), VCruise, 1);
    [CD, ~, ~] = dragCoeff(CL, MCC1a, type);
    T = thrust(MCC1a, TSL_Mil*1.1, hCC(i), 1);
    u = CD/CL*WCC(i)/T;
    WCC(i+1) = WCC(i)*exp(-TSFC(MCC1a, hCC(i), 1, type)/VCruise*(hCC(i+1) - hCC(i))/...
        (1 - u));
end

W = WCC(end);
betaf = W/WTO;

end

