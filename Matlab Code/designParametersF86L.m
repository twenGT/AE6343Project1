function [ ] = designParametersF86L(~)
%Design parameters for F86L

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

global CL_Max
global muTO

global VCruise
global VCombat

global h3
global h4
global h6
global h8


rho_ref = 0.002377; %slugs/ft^3
T_ref = 518.688;    %R
P_ref = 2116.8;     %psft
a_ref = 1116.45;    %ft/s
g = 32.174;         %ft/s^2

%F-86L Data
% AR = 4.6;
% taper_ratio = 0.6;

%MATTINGLY pg.36
% e = 0.8;

WC = 210;       %lbf
WP = 432;       %lbf
WpreTakeOff = 0;

TSL_Max = 7650; %lbf
TSL_Mil = 5550; %lbf
TSL_Nml = 5100; %lbf

%SLIDES, Single slot
CL_Max = 1.3;
%CL_MaxLD = 2;
muTO = 0.05;

%468 knots
VCruise = 468*1.688;
%536 knots
VCombat = 536*1.688;


h3 = 35400;     %ft
h4 = 38700;     %ft
h6 = 47550;     %ft
h8 = 37000;     %ft


end