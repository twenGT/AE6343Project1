function [ ] = designParametersAPTA( ~ )
%Design parameters for Advanced Pilot Training Aircraft

global rho_ref
global T_ref
global P_ref
global a_ref
global g

% global AR
% global e

global WC
global WP
global WpreTakeOff

global TSL_Max
global TSL_Mil
global TSL_Nml
global BCM

global CL_Max
global muTO

global VCruise
global VDash


rho_ref = 0.002377; %slugs/ft^3
T_ref =  518.688;   %R
P_ref = 2116.8;     %psft
a_ref = 1116.45;    %ft/s
g = 32.174;         %ft/s^2

% AR = 4.6;
% taper_ratio = 0.6;

WC = 550;       %lbf
WP = 750;       %lbf

Wstart  = 35;   %lbf
WwarmUp = 25*30;%lbf
WrunUp  = 85;   %lbf
WpreTakeOff = Wstart + WwarmUp + WrunUp;

TSL_Max = 9000;%lbf
TSL_Mil = 7500; %lbf
TSL_Nml = 6000; %lbf

%MATTINGLY pg.36
% e = 0.8;

%SLIDES, improved aero
CL_Max = 1.4;
muTO = 0.05;

%480 knots
VCruise = 480*1.688;
%622 knots
VDash = 622*1.688;

BCM = 0.8;

end