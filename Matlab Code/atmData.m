function [T, P, rho, a] = atmData(h)
%RAYMER pg.73
%Input altitiude h[ft]
%Output pressure P[psf], temperature T[R], density rho[slugs/ft^3]


global T_ref
global P_ref
global rho_ref

B = 0.003566;   %R/ft
gRB = 5.26;

P = P_ref*(1 - B*h/T_ref)^gRB;
rho = rho_ref*(1 - B*h/T_ref)^(gRB-1);

if h < 36090
    T = T_ref - B*h;
else
    T = 389.97;
end

a = sqrt(1.4*1716.5*T);

end

