function [ T, rho ] = atmData( h_ft )
%From Raymer pg 73
%Input altitiude h[ft]
%Output pressure P[Pa], temperature T[K], density rho[kg/m^3]

h = h_ft*0.3048;

T_0 = 288.16;   %degC
B = 0.0065;     %K/m
% P_0 = 101350;   %Pa
rho_0 = 1.2255; %kg/m^3
gRB = 5.26;         

% P = P_0*(1 - B*h/T_0)^gRB;
rho = rho_0*(1 - B*h/T_0)^(gRB-1);
if h < 11000
    T = T_0 - B*h;
else
    T = 216.65;

end

