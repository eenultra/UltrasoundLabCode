% calHIFU - measure peak pressure values for HIFU tranducers using the
% PicoScope and Membrane, in CNC tank

Runs    = 3; % number of repeats
mVrange = 20:20:460; % Agilent Voltage Range
freq    = 3.55E6; % Trasnducer Freq
pDur    = 20E-6; % Pulse duration, in us
nBst    = round(freq*pDur); % number of cycles for this pulse duration and freq

agopen
agoff;
agSetVolt(25E-3); % sets low voltage to start
agSetFreq(freq);  % sets ultrasound freq
agSetBcnt(nBst);  % sets number of cycles in burst

% Config PicoScope and init datasets
picoStart;
% CHECK Pico Config before running
picoConfig; 

% Define Data
pData  = zeros(nMaxSamp,length(mVrange),Runs);
vData  = zeros(nMaxSamp,length(mVrange),Runs);

hydroCal = 343; % for membrane 343mV/MPa @ 1MHz, 349 mV/MPa @ 3MHz
probe    = 10;  % scope probe atten x10

% data locations, check manually
vSt = 300; vEn  = 900;
pSt = 3000;pEn  = 3500;

%%
datName = '190619_pkPcal_H102-98_3p55MHz_R1';

picoShow = 0; % does not display data from picoGrab
for i=1:Runs
    for j=1:length(mVrange)
        agSetVolt(mVrange(j)*1E-3); pause(0.1);%
        agon
        picoGrab;pause(1);
        pData(:,j,i)  = mean(chA,2)/hydroCal;
        vData(:,j,i)  = (mean(chB,2)/1E3)*probe;
        clear chA chB
        agoff
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

 agSetVolt(25E-3);

save([datName '.mat'],'mVrange','freq','pDur','nBst','pData','vData','pppAve','pppStd','pnpAve','pnpStd','vpkAve','vpkStd','timeNs','hydroCal');
 
agclose
picoStop






