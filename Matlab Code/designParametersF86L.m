function [ ] = designParametersF86L(~)
%Design parameters for F86L

global type

global rho_ref
global T_ref
global P_ref
global a_ref
global g

global WC
global WP
global WpreTakeOff

global CL_Max
global CL_noHL
global muTO

global VCruise
global VCombat
global VMaxSL

global h3
global h4
global h6
global h8
global h9

global t5
global t7
global t9

global Rcombat
global nCombat

global WTO2S

%type = 1 for F86L
type = 1;

rho_ref = 0.002377; %slugs/ft^3
T_ref = 518.688;    %R
P_ref = 2116.8;     %psft
a_ref = 1116.45;    %ft/s
g = 32.174;         %ft/s^2

WC = 210;       %lbf
WP = 432;       %lbf
WpreTakeOff = 0;

%SLIDES, Single slot
CL_Max = 1.1;
CL_noHL = 0.85;
muTO = 0.05;

%458 knots
VCruise = 458*1.688;
%536 knots
VCombat = 536*1.688;
%602 knots
VMaxSL  = 550*1.688;

h3 = 35400;     %ft
h4 = 38700;     %ft
h6 = 47550;     %ft
h8 = 37000;     %ft
h9 = 35000;     %ft

t5 = 10;        %min
t7 = 5;         %min
t9 = 10;        %min

Rcombat = 550;  %nm
nCombat = 1.4;

WTO2S = 20:0.1:160;

end