%Agilent Start

burstcount = 30;    % set burst number for Agilent
frequency  = 5;     % in MHz
volts      = 16;    % in mV pk-pk
PRF        = 100E-3; % burst period 
mode       = 'IMM'; % set trigger mode for Agilent


agopen                   % Starts RS232 com
agoff                    % switches output to OFF
agsetTRIG(mode)
agSetBcnt(burstcount);
agSetFreq(frequency*1E6);
agSetVolt(volts/1E3);
agSetPRF(PRF);
agsetBSTMOD;

clear burstcount frequency volts mode PRF

disp(' ');
disp('Agilent ready.....');
disp('Output off');