%% HIFU Scan/Exposure Code

clear all; close all; clc

%% Connect to Hardware

%Thorlabs Stage
LS3open;
% Function Generator
fnOpen
% QC 
QCopen

fs         = 250;                       % sample frequency in MHz
noChannels = 2;                         % active channel number
aqTime     = 5;                         % approx total aquisition time in us
aqInt      = round((aqTime * fs)/1024); % approx number of mem blocks needed for aqTime
chDR       = [200 200];                 % [Ch0 Ch1] dynamic range in mV
chIM       = [1 1];                     % channel input impedance, 1 - 50Ohm, 0 - 1MOhm
TrigType   = 1;                         % if 1 then external trig is used, internal all else 
                                             
daqStSingleAq(aqInt,noChannels,fs,chDR,chIM,TrigType); % check card is powered and connected!

global cardInfo
%% Locations for HIFU Exposures
% start position for scan
zSt    = 12.5;   % fixed z position for scan in mm
yCt    = 12.5;   % y centre position for scan in mm
xCt    = 12.5;   % x centre position for scan in mm

% scan geometry 
yRng = 1;   % y scan range in mm
yRes = 0.1;  % y resolution in mm 
xRng = 1;   % x scan range in mm
xRes = 0.1;  % x resolution in mm

if yCt-(yRng/2) < 0 || xCt-(xRng/2) < 0
    disp('Outside of movement range');
    return
end
% define scan vectors
yPoints = yCt-(yRng/2):yRes:yCt+(yRng/2);
xPoints = xCt-(xRng/2):xRes:xCt+(xRng/2);

%%

vltDat = zeros(cardInfo.setMemsize,length(yPoints));

