%RBF: caibration of trasnducers, using power amp/function gen, with LeCroy
%scope connected
% James McLaughlan
% University of Leeds
% Jan 2019

clearvars -except lc MT AG

fileName = '200110_RFB_ar57_old1p1MHz';

%Ensure LeCroy Scope, Agilent Fun and scales are connected
agoff; % to ensure the transducer is not on
agSetBSTstat('OFF'); % switch func to CW mode

nDat = 250001; %length of data from scope Ch1 (voltage)

mVrange = 25:25:400; %mV range for calibration
f0      = 1.1E6;     %freq of calibration

agSetFreq(f0);

aveP = zeros(length(mVrange),1);
stdP = zeros(length(mVrange),1);
pkpV = zeros(length(mVrange),1);
pknV = zeros(length(mVrange),1);
aveV = zeros(nDat,length(mVrange));

input('Zero M-T scales, then press enter');

for i=1:length(mVrange)
    
agSetVolt(mVrange(i)*1E-3);pause(1);
[mTotPow,stdTotPow,xT,yV] = rtbManMethScope(lc,nDat);

aveP(i,1) = mTotPow;
stdP(i,1) = stdTotPow;
aveV(:,i) = yV;
pkpV(i,1) = max(yV);
pknV(i,1) = abs(min(yV));

figure(1);errorbar(mVrange,aveP,stdP,'x');xlabel('mV');ylabel('Acoustic Power (W)');drawnow;
figure(2);plot(mVrange,pkpV+pknV,'x');xlabel('mV');ylabel('Pk-Pk Voltage (V)');drawnow;

end

save(fileName,'aveP','stdP','aveV','pkpV','pknV','xT','mVrange','f0');