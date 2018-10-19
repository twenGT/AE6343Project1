function [T, alpha] = thrust(M, TSL, h, scenario)
%scenario == 1: military
%scenario == 2: maximum (with after-burner)

global rho_ref

[ ~, ~, rho, ~ ] = atmData( h );
sigma = rho/rho_ref;

if scenario == 1
    alpha = 0.76*(0.907+0.262*(abs(M-0.5))^1.5)*sigma^0.7;
elseif scenario == 2
    alpha = (0.952 + 0.3*(M-0.4)^2)*sigma^0.7;
else
    alpha = 1;
end

T = alpha*TSL;

end

