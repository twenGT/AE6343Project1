function [ TAS ] = TASCalc( IAS, h )

[~, ~, rho, ~] = atmData(h);
[~, ~, rho0, ~] = atmData(0);

TAS = IAS*sqrt(rho0/rho);

end

