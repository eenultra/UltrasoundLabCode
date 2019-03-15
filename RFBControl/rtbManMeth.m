%RBF: Manual Recording Method from user manual (p25)
% James McLaughlan
% University of Leeds
% Jan 2019

function [mTotPow,stdTotPow] = rtbManMeth


M0=zeros(4,1); % M(0)measurement time
M10=zeros(4,1); % M(10)measurement time
M20=zeros(4,1); % M(20) measurement time

c = 1482.36; %m/s sound speed at 20degC from Table 2 in manual
g = 9.81;    %m/s^2 gravity constant
F = 1; %NPL calibration factor (see sheet) output/input power ratio

for i=1:4 % 4 repeats of this process
    disp(['Run: ' num2str(i) ' of 4']);
    M0(i,1) = mtRead; %M(0) TXD_OFF

    agon %turn on TXD
    disp('transducer on')
    pause(10);

    M10(i,1) = mtRead; %M(10) TXD_ON

    agoff %turn off TXD
    disp('transducer off')
    pause(10);

    M20(i,1) = mtRead; %M(20) TXD_OFF


end

OFF_ON = M10-M0;
ON_OFF = M10-M20;

mW   = mean([OFF_ON;ON_OFF]);
stdW = std([OFF_ON;ON_OFF]);

mTotPow   = (mW * c * g * F)/1E3; %W %see page 27 from manual
stdTotPow = (stdW * c * g * F)/1E3; %W



