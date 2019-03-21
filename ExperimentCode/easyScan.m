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
yCt    = 25;   % y centre position for scan in mm
xCt    = 25;   % x centre position for scan in mm
% scan geometry 
yRng = 0.1;   % y scan range in mm
yRes = 0.01;  % y resolution in mm 
xRng = 0.1;   % x scan range in mm
xRes = 0.01;  % x resolution in mm

if yCt-(yRng/2) < 0 || xCt-(xRng/2) < 0
    disp('Outside of movement range');
    return
end
% define scan vectors
yPoints = yCt-(yRng/2):yRes:yCt+(yRng/2);
xPoints = xCt-(xRng/2):xRes:xCt+(xRng/2);

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

posErr = 0.01; %error on move, +/- 0.1 for linear, 0.01 for compact 
nS     = 0; %to give scan count
for i=1:length(xPoints)
    vltDat = zeros(cardInfo.setMemsize,length(yPoints));
    for j=1:length(yPoints) 
        nS = nS + 1;
        disp(['Scan no ' num2str(nS) '/' num2str(length(yPoints)* length(xPoints)) ', ' num2str(roundn((nS/(length(yPoints)* length(xPoints)))*100,-1)) '% completed.']);      
        %put in code to make the scan raster to save time
        if rem(i, 2) == 0
            rY = (length(yPoints) - j)+1;
        else
            rY  = j;
        end
        
        LS3move(xPoints(i),yPoints(rY),zSt,50,posErr);
        % need to check stage is in correct position before aquiring data.
        % added timeout to stop inf loop.
        posFlag = 0;
        tOut    = 60;
        t2      = clock; % current time
        while (etime(clock,t2)<timeout)
        pos = L3Sgetpos;
            if (abs(xPoints(i)-pos(1)) <= posErr) == 1 && (abs(yPoints(rY)-pos(2)) <= posErr) == 1 && (abs(zSt-pos(3)) <= posErr) == 1
                break
            end
        end
        
        avDAT0 = zeros(cardInfo.setMemsize,nPulse);
        for k=1:nPulse
        [t,DAT]= daqSAqu; 
        avDAT0(:,k) = DAT(:,1);
        end      
        vltDat(:,rY) = mean(avDAT0,2);
        mapDat(i,rY) = range(vltDat(datSt:datEn,rY));
        figure(4);imagesc(xPoints,yPoints,mapDat);colormap('hot');colorbar;drawnow;
    end
    %save ([fname '_x' num2str(xPoints(i)*1E3) 'um.mat'],'xPoints','yPoints','vltDat','mapDat','zSt','t','fs','cardInfo');
end

%save ([fname '_map.mat'],'xPoints','yPoints','mapDat','zSt','t','fs','cardInfo');

%%

close all
daqEnSingleAq;






