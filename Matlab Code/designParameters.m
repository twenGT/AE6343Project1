function [ ] = designParameters( ~ )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

global AR
global e

AR = 4.6;
taper_ratio = 0.6;
%d is obtained from ANDERSON pg110 Fig2.39
d = 0.03;
e = 1/(1+d);


end

