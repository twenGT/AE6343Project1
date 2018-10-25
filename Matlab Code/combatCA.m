function [ TSL2WTO, leg ] = combatCA( beta, h, V, loadFactor, type )
%Duration t in minutes

global WTO2S

[~, ~, rho, a] = atmData(h);
q = .5*rho*V^2;
M = V/a;

[~, alpha] = thrust(M, 0, h, 2);
[~, K1, CD0] = dragCoeff(0, M, type);

TSL2WTO = (beta/alpha)*((loadFactor^2*K1*beta/q)*(WTO2S) + CD0./((beta/q)*WTO2S));

leg = 'Combat';

end

