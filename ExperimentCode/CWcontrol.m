% Example Matlab code used for controlling experimental apparatus for
% performing the CW exposures study in 'Controllable nucleation of cavitation from 
% plasmonic gold nanoparticles for enhancing high intensity focused ultrasound applications' JoVE.
%
% James McLaughlan
% Jun 2018
% University of Leeds
% 
% This code is only for example purposes, as it is specific to the hardware
% used, but should be illustrative of how it was done.

clearvars -except lc ZO QC AG RT EM % clears workspace apart from specific vari
% Set up parameters 

nCyc = 330000;  % No of cycles, every 10Hz (laser rep rate)
f0   = 3.3E6;   % freq
dur  = 15;      % exposure time
PrPs = 1;       % pre and post acq time
dV   = 140;     % mV function generator drive setting (can be array)

%Initialise the DAQ Card
SPcardSt(2000,500,243) % specific control code for the DAQ card
global cardInfo
    
disp('Ready?');pause;

for j = 1:length(dV)
    
    name = ['20180813_P1_NR_839nm_Lon_40PC_' num2str(dV(j)) 'mV']; %set filename for saving

    ZOscan(69,51,57); % moved 3-d positioning system. 

    fs     = cardInfo.setSamplerate;
    Na     = round((dur + 2*PrPs)/0.1);
    data   = zeros(cardInfo.setMemsize,Na);

    agSetVolt(dV(j)*1E-3);pause(0.1); % set voltage on function generator
    agSetBcnt(nCyc);pause(0.1);% set burst count on function generator

    disp(['Drive: ' num2str(dV(j)) 'mV, Start!']);

    for i = 1:Na

        if ((PrPs/0.1) == i)
            agon % turn on function generator
            disp('HIFU On!');
        end

        if (round(7.5/0.1) == i)
            disp('7.5s');
        end

        [t,DAT]   = SPcardAq; % aquire data
        data(:,i) = DAT(:,1);

        if (((dur+PrPs)/0.1) == i)
            agoff % turn off function generator
            disp('HIFU Off');
        end

    end
    disp('Stop');
    agoff
    agSetBcnt(5);

    disp('Saving...');
    save([name '.mat'],'data','t','f0','fs','dur','PrPs','dV');

end

SPcardEn;
    
  