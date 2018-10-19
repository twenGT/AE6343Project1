function [ WTO2S ] = landingConstraint( beta, CL )

global rho_ref
global g

k_TD = 1.15;
mu_b = .4; %% Coefficient of friction between .4 -.5 for braking 120-160 kts TD speed NTSB
CD = 0.8*CL/k_TD^2;
EL = CD;

tfr = 3;

% Mattingly pg. 53
% Note Mattingly does not consider SA in total landing distance. 
%a = (beta/(rho_ref*g*E_L))*log(1 + E_L/(mu_b+(T*alpha/(beta*(WTO)))*(CL_Max/k_TD^2)));
a = (beta/(rho_ref*g*EL))*log(1 + EL/(mu_b*(CL/k_TD^2)));
b = tfr*k_TD*sqrt(2*beta/(rho_ref*CL));
c = 2000; %Landing distance

WTO2S = ((-b + sqrt(b^2 + 4*a*c))/(2*a))^2;

end

