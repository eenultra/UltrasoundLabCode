%%
fs         = 2500;                      % sample frequency in MHz
noChannels = 2;                         % active channel number
aqTime     = 1;                         % approx total aquisition time in us
aqInt      = round((aqTime * fs)/1024); % approx number of mem blocks needed for aqTime
chDR       = [200 200];                 % [Ch0 Ch1] dynamic range in mV
chIM       = [1 1];                     % channel input impedance, 1 - 50Ohm, 0 - 1MOhm
TrigType   = 1;                         % if 1 then external trig is used, internal all else 


daqStSingleAq(aqInt,noChannels,fs,chDR,chIM,TrigType); % check card is powered and connected!

global cardInfo

%%
nPulse = 100;
avDAT0 = zeros(cardInfo.setMemsize,nPulse);

for k=1:nPulse
     [t,DAT]= daqSAqu; 
     avDAT0(:,k) = DAT(:,1);
end

figure(4)
plot(t,mean(avDAT0,2));

%%
daqEnSingleAq






        
        