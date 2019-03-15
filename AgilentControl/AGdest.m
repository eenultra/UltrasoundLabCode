function AGdest(AG,Vp,PRF,Dur,fs)

%AGdest(AG,410,10,0.2,100E3);

% 100 kHz, 2 MHz
% 150 kHz, 3 MHz

% PRF = 10;   % PRF in Hz
% Dur = 0.20;     % exposure duration
% fs  = 100E3; % 1/dur of 20 cycle, for ARB
% 
% Vp  = 410;
      
agSetFreq(fs);
agSetVolt(Vp/1E3);
fprintf(AG,'BURS:NCYC 1');
fprintf(AG,['BURS:INT:PER ' num2str(1/PRF)]);
   
%input('Are Settings correct?');

agon
pause(Dur);
agoff





    
