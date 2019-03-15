% connect to Mettler-Toledo scales, used from RFB measurements
% Chris Adams and James McLaughlan
% University of Leeds
% Jan 2019

global MT

MT = visa('ni','ASRL13::INSTR'); % check COM port (typically 13) when using USB connection
disp('M-T scales connected, but not open');