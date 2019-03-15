T   = 10E-6; % 10us exposure duration
PRF = 1E3;   % 1 kHz PRF
Dur = 120;    % 60s exposure duration
f0  = 2E6;   % 2 MHz tone
cyc = round(2E6*10E-6); % number of cycles for a 10us pulse at 2 MHz
fs  = round(1/T); % freq used when ARB pulse is used.


% 110 mV for 100 kPa, 230 for 200 kPa, 280 for 250 kPa at 2 MHz
% 200 mV for 100 kPa, 400 for 200 kPa, 490 for 250 kPa with Chirp

Vp  = 490;
%Typ = 'Tone';
Typ = 'Chirp';

switch(Typ)
    case 'Tone'

    agSetFreq(f0);
    agSetVolt(Vp/1E3);
    fprintf(AG,['BURS:NCYC ' num2str(cyc)])
    fprintf(AG,['BURS:INT:PER ' num2str(1/PRF)]);
    

    case 'Chirp'
        
    agSetFreq(fs);
    agSetVolt(Vp/1E3);
    fprintf(AG,['BURS:NCYC 1']);
    fprintf(AG,['BURS:INT:PER ' num2str(1/PRF)]);
        
end
    
input('Are Settings correct?');


agon
pause(Dur);
agoff





    
