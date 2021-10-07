% calHIFU - measure peak pressure values for HIFU tranducers using the
% Spectrum and Needle, in SBS

Runs    = 3; % number of repeats
mVrange = 20:20:200; % Agilent Voltage Range
freq    = 3.3E6; % Trasnducer Freq
nBst    = 10; % number of cycles for this pulse duration and freq
nCyc    = 20; % number of repeat pulses

fnOff;

fnSetVolt(20E-3); % sets low voltage to start
fnSetFreq(freq);  % sets ultrasound freq
fnSetBcnt(nBst);  % sets number of cycles in burst

%% Card Setup for pulsed scan

fs         = 250;                       % sample frequency in MHz
noChannels = 2;                         % active channel number
aqTime     = 60;                       % approx total aquisition time in us
aqInt      = round((aqTime * fs)/1024); % approx number of mem blocks needed for aqTime
chDR       = [200 5000];                % [Ch0 Ch1] dynamic range in mV
chIM       = [1 0];                     % channel input impedance, 1 - 50Ohm, 0 - 1MOhm
TrigType   = 1;                         % if 1 then external trig is used, internal all else 
                                             
daqStSingleAq(aqInt,noChannels,fs,chDR,chIM,TrigType); % check card is powered and connected!

global cardInfo

%%

% Define Data
pData  = zeros(cardInfo.setMemsize,length(mVrange),Runs);
vData  = zeros(cardInfo.setMemsize,length(mVrange),Runs);

%hydroCal = 343; % for membrane 343mV/MPa @ 1MHz, 349 mV/MPa @ 3MHz
probe    = 10;  % scope probe atten x10

% data locations, check manually
vSt = 300; vEn  = 900;
pSt = 10000;pEn  = 14000;

%%
datName = '211007_pkPcal_H102_3p3MHz';

for i=1:Runs
    for j=1:length(mVrange)
        fnSetVolt(mVrange(j)*1E-3); pause(0.1);%
        
        fnOn;pause(0.1);

        chA = zeros(cardInfo.setMemsize,nCyc);
        chB = zeros(cardInfo.setMemsize,nCyc);       
        for k = 1:nCyc
            [t,DAT]   = daqSAqu; % aquire data
            chA(:,k) = DAT(:,1);
            chB(:,k) = DAT(:,2);
        end   
        pData(:,j,i)  =  HydrophoneInverseFilter(mean(chA,2),cardInfo.setSamplerate,2);
        vData(:,j,i)  = (mean(chB,2)/1E3)*probe;       
        fnOff
        
        figure(1);plot(timeNs/1E3,pData(:,j,i));drawnow
        figure(2);plot(timeNs/1E3,vData(:,j,i));drawnow
    end   
end

 pppAve = mean(max(pData(pSt:pEn,:,:),[],1),3);   % pk pos pressure
 pppStd = std(max(pData(pSt:pEn,:,:),[],1),[],3);
 pnpAve = mean(abs(min(pData(pSt:pEn,:,:),[],1)),3); % pk neg pressure
 pnpStd = std(abs(min(pData(pSt:pEn,:,:),[],1)),[],3);
 vpkAve = mean(range(vData(vSt:vEn,:,:),1),3);   % pk-pk voltage from scope probe
 vpkStd = std(range(vData(vSt:vEn,:,:),1),[],3);
 
 figure(3);
 errorbar(mVrange,pppAve,pppStd,'bx');hold on
 errorbar(mVrange,pnpAve,pnpStd,'ro');hold off
 xlabel('Agilent Range (mV)');ylabel('Peak Pressure (MPa)');
 
 figure(4);
 errorbar(mVrange,vpkAve,vpkStd,'bx');
 xlabel('Agilent Range (mV)');ylabel('Pk-Pk Drive Voltage (V)');

fnSetVolt(20E-3);

save([datName '.mat'],'mVrange','freq','pDur','nBst','pData','vData','pppAve','pppStd','pnpAve','pnpStd','vpkAve','vpkStd','timeNs','hydroCal');
 






