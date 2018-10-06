function [ CL ] = liftCoeff( W, S, h, u, n )
%Calculates coefficient of lift

[~, ~, rho, ~] = atmData(h);
CL = 2*n*W/(rho*u^2*S);

end

