function [ ] = designParametersAPTA( ~ )
%Design parameters for Advanced Pilot Training Aircraft

global rho_ref
global g


% global AR
% global e

global WC
global WP
global WpreTakeOff

global TSL_Max
global TSL_Mil
global TSL_Nml

rho_ref = 0.002377; %slugs/ft^3
g = 32.174;         %ft/s^2

AR = 4.6;
taper_ratio = 0.6;

WC = 210;       %lbf
WP = 432;       %lbf

Wstart  = 35;   %lbf
WwarmUp = 25*30;%lbf
WrunUp  = 85;   %lbf
WpreTakeOff = Wstart + WwarmUp + WrunUp;


TSL_Max = 7650; %lbf
TSL_Mil = 5550; %lbf
TSL_Nml = 5100; %lbf

%MATTINGLY pg.36
% e = 0.8;


end