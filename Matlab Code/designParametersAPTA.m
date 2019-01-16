function [ ] = designParametersAPTA( ~ )
%Design parameters for Advanced Pilot Training Aircraft

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DO NOT CHANGE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
global h14

global nCombat

global WTO2S

%type = 2 for APTA
type = 2;

rho_ref = 0.002377; %slugs/ft^3
T_ref   =  518.688; %R
P_ref   = 2116.8;   %psft
a_ref   = 1116.45;  %ft/s
g       = 32.174;   %ft/s^2

WTO2S = 20:0.1:160;

%%%%%%%%%%%%%%%%%% FEEL FREE TO CHANGE PARAMETERS BELOW %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% PLEASE BE REASONABLE :D %%%%%%%%%%%%%%%%%%%%%%%%%

%Crew weight
WC = 550;           %lb
%Payload weight
WP = 750;           %lb

%Fuel consumption prior to take off
Wstart  = 35;       %lb
WwarmUp = 25*30;    %lb
WrunUp  = 85;       %lb
WpreTakeOff = Wstart + WwarmUp + WrunUp;

%From slides, improved aerodynamics compared to F-86L
CL_Max  = 1.4;
CL_noHL = 0.9;
muTO    = 0.05;

%Combat speed
VCombat = 300*1.688;
%Dash Mach number
MDash = 1.1;
%Best cruise Mach number
BCM   = 0.8;

%Cruise distances for corresponding mission phases
r4  = 150;  %nm
r5  = 100;  %nm
r8  = 100;  %nm
r12 = 150;  %nm

%Flying time for corresponding mission phases
t6  = 20;   %min
t10 = 20;   %min
t14 = 30;   %min

%Cruise altitude for corresponding mission phases
h5  = 20000;    %ft
h6  = 20000;    %ft
h10 = 15000;    %ft
h14 = 10000;    %ft

%IAS for rendezvous and simulated air refueling 
%300 knots
IAS5 = 300*1.688;
%250 knots
IAS6 = 250*1.688;

V5 = TASCalc( IAS5, h5 );
V6 = TASCalc( IAS6, h6 );

%Combat load factor
nCombat = 3;

end