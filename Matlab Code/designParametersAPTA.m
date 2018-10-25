function [ ] = designParametersAPTA( ~ )
%Design parameters for Advanced Pilot Training Aircraft

global type

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

global CL_Max
global CL_noHL
global muTO

global V5
global V6
global VCombat

global MDash
global BCM

global r4
global r5
global r8
global r12

global t6
global t10
global t14

global h5
global h6
global h10

global nCombat

global WTO2S

%type = 2 for APTA
type = 2;

rho_ref = 0.002377; %slugs/ft^3
T_ref   =  518.688; %R
P_ref   = 2116.8;   %psft
a_ref   = 1116.45;  %ft/s
g       = 32.174;   %ft/s^2

% AR = 4.6;
% taper_ratio = 0.6;

WC = 550;           %lbf
WP = 750;           %lbf

Wstart  = 35;       %lbf
WwarmUp = 25*30;    %lbf
WrunUp  = 85;       %lbf
WpreTakeOff = Wstart + WwarmUp + WrunUp;

%SLIDES, improved aero
CL_Max  = 1.4;
CL_noHL = 0.9;
muTO    = 0.05;

VCombat = 300*1.688;
%VCombat = 1500;
MDash = 1.1;
BCM   = 0.8;

r4  = 150;  %nm
r5  = 100;  %nm
r8  = 100;  %nm
r12 = 150;  %nm

t6  = 20;   %min
t10 = 20;   %min
t14 = 30;   %min

h5  = 20000;     %ft
h6  = 20000;     %ft
h10 = 15000;     %ft

%300 knots
IAS5 = 300*1.688;
%250 knots
IAS6 = 250*1.688;

V5 = TASCalc( IAS5, h5 );
V6 = TASCalc( IAS6, h6 );

nCombat = 3;

WTO2S = 20:0.1:160;

end