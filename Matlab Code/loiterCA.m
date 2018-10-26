function [ TSL2WTO, leg ] = loiterCA( beta, h, V, type)

global WTO2S

[~, ~, rho, a] = atmData(h);
q = .5*rho*V^2;
M = V/a;

[~, alpha] = thrust(M, 0, h, 1);
[~, K1, CD0] = dragCoeff(0, M, type);

TSL2WTO = (beta/alpha)*((K1*beta/q)*(WTO2S) + CD0./((beta/q)*WTO2S));

leg = 'Loiter';

end

