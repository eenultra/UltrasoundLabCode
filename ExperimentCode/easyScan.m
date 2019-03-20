% Code to control the Thorlab stage and 2.5GHz DAQ for performing 2D scans
% with the easyPAM PA module. No laser control at this point.

% James McLaughlan
% University of Leeds
% March 2019

%% Initilise and config DAQ and Stages

fs         = 2500;                      % sample frequency in MHz
noChannels = 2;                         % active channel number
aqTime     = 5;                         % approx total aquisition time in us
aqInt      = round((aqTime * fs)/1024); % approx number of mem blocks needed for aqTime
chDR       = [200 200];                 % [Ch0 Ch1] dynamic range in mV
chIM       = [1 1];                     % channel input impedance, 1 - 50Ohm, 0 - 1MOhm
TrigType   = 0;                         % if 1 then external trig is used, internal all else 

LS3open;                                               % connect and init thorlab stages !!CHECK S/N are correct!!
daqStSingleAq(aqInt,noChannels,fs,chDR,chIM,TrigType); % check card is powered and connected!

global cardInfo
%need something here for laser control, but at present QC system is not
%working

%% Configure 2D scan area, it is assumed that height (z) is preconfig'd due to time of flight.

nPulse = 10;   % number of repeat laser pulses at a specific location
% start position for scan
zSt    = 25;   % fixed z position for scan in mm
ySt    = 25;   % y start position for scan in mm
xSt    = 25;   % x start position for scan in mm
% scan geometry 
yRng = 10;   % y scan range in mm
yRes = 1;  % y resolution in mm 
xRng = 10;   % x scan range in mm
xRes = 1;  % x resolution in mm
% define scan vectors
yPoints = ySt:yRes:ySt+yRng;
xPoints = xSt:xRes:xSt+xRng;

%% Start Scan

mapDat = zeros(length(xPoints),length(yPoints));
datSt = 500;  % start point of real data
datEn = 5000; % end point of real data

fname = '190220_TestScan';

figure(4);
imagesc(xPoints,yPoints,mapDat);
colormap('hot');colorbar
xlabel(gca,'X axis (mm)');ylabel(gca,'Y axis (mm)');

input('Ready to start?');

for i=1:length(xPoints)
    vltDat = zeros(cardInfo.setMemsize,length(yPoints));
    for j=1:length(yPoints)
        %put in code to make the scan raster to save time
        if rem(i, 2) == 0
            rasterY = (length(yPoints) - j)+1;
        else
            rasterY  = j;
        end
        LS3move(xPoints(i),yPoints(rasterY),zSt,50)
%         pErr = -2;
%         posFlag = 0;
%         while posFlag == 0
%         LS3move(xPoints(i),yPoints(rasterY),zSt,50); 
%         pos = L3Sgetpos;
%             if (roundn(pos(1), pErr) == roundn(xPoints(i), pErr)) && (roundn(pos(2), pErr) == roundn(yPoints(rasterY), pErr))
%               posFlag = 1;  
%             end
%         end
        
        avDAT0 = zeros(cardInfo.setMemsize,nPulse);
        for k=1:nPulse
        [t,DAT]= daqSAqu; 
        avDAT0(:,k) = DAT(:,1);
        end      
        vltDat(:,rasterY) = mean(avDAT0,2);
        mapDat(i,rasterY) = range(vltDat(datSt:datEn,rasterY));
        figure(4);imagesc(xPoints,yPoints,mapDat);colormap('hot');colorbar;drawnow;
    end
    save ([fname '_x' num2str(xPoints(i)*1E3) 'um.mat'],'xPoints','yPoints','vltDat','mapDat','zSt','t','fs','cardInfo');
end

save ([fname '_map.mat'],'xPoints','yPoints','mapDat','zSt','t','fs','cardInfo');

%%

close all
daqEnSingleAq;






