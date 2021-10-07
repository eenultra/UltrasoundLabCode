%% HIFU Exposure Code for scan and CW exposure

clear all; close all; clc

%% Connect to Hardware

%Thorlabs Stage
LS3open;
% Function Generator
fnOpen
% QC 
QCopen

%% Locations for HIFU Exposures and scan range

res   = 0.5;  %mm distance between exposures
centX = 9;    %mm centre pos for exposure
centY = 6.5;  %mm centre pos for exposure
centZ = 4;    %mm centre pos for exposure

rng  = 3;  %mm x/y scan size
sRes = 0.2; %mm resolution of 2D scan
xRng = (-(rng/2):sRes:(rng/2))+centX;  
yRng = (-(rng/2):sRes:(rng/2))+centY; 

expPOS = [centX-res,centY+res,centZ;...  % HIFU location 1 -0.5x,+0.5y
         centX+res,centY+res,centZ;...   % HIFU location 2 +0.5x,+0.5y
          centX+res,centY-res,centZ;...  % HIFU location 3 +0.5x,-0.5y
          centX-res,centY-res,centZ;...  % HIFU location 4 -0.5x,-0.5y
          centX,centY,centZ];            % HIFU location 5

%expPOS = [centX,cenY,centZ]; % position for single HIFU exposure at centre of tumour

%% Card Setup for pulsed scan
fs         = 250;                       % sample frequency in MHz
noChannels = 2;                         % active channel number
aqTime     = 120;                       % approx total aquisition time in us
aqInt      = round((aqTime * fs)/1024); % approx number of mem blocks needed for aqTime
chDR       = [200 5000];                % [Ch0 Ch1] dynamic range in mV
chIM       = [1 0];                     % channel input impedance, 1 - 50Ohm, 0 - 1MOhm
TrigType   = 1;                         % if 1 then external trig is used, internal all else 
                                             
daqStSingleAq(aqInt,noChannels,fs,chDR,chIM,TrigType); % check card is powered and connected!

global cardInfo

%% Aqu settings for pulsed scan

nCyc = 5;       % No of cycles, every 10Hz (laser rep rate)
f0   = 3.3E6;    % freq
dV   = 45;       % mV function generator drive setting 

expName = '210727_2D_Test';

%% Run X/Y Scan
    
fnSetVolt(dV*1E-3);pause(0.1); % set voltage on function generator
fnSetBcnt(nCyc);pause(0.1);    % set burst count on function generator

input('Ready (amp on)?');
disp(['Drive: ' num2str(dV) 'mV, Start!']);

tic
for j = 1:length(yRng)
    pcdScanDat = zeros(cardInfo.setMemsize,nCyc,length(xRng));
    vltScanDat = zeros(cardInfo.setMemsize,nCyc,length(xRng));    
 
    
    for k=1:length(xRng)
    pos    = LS3move(xRng(k),yRng(j),centZ,25,0.1);
    name   = [expName '_yPOS' num2str(yRng(j)*100) 'um']; %set filename for saving
   
    disp(['Xpos: ' num2str(xRng(k)) 'mm, Ypos:' num2str(yRng(j)) 'mm, Zpos: ' num2str(centZ) 'mm']);
 
    QCrun    
    fnOn
        for i = 1:nCyc
            [t,DAT]     = daqSAqu; % aquire data
            pcdScanDat(:,i,k) = DAT(:,1);
            vltScanDat(:,i,k) = DAT(:,2);
        end       
    fnOff;    
    end
    
    disp('Saving x line scan data');   
    save([name '.mat'],'pcdScanDat','vltScanDat','t','f0','fs','dV','xRng','yRng');
end
toc

fnSetBcnt(5);
QCstop

pos = LS3move(12.5,12.5,25,25,0.1); % move stage out of the way
disp('Turn on pump/vac');

%% Card Setup for exposures

fs         = 250;                       % sample frequency in MHz
noChannels = 2;                         % active channel number
aqTime     = 4E3;                       % approx total aquisition time in us
aqInt      = round((aqTime * fs)/1024); % approx number of mem blocks needed for aqTime
chDR       = [500 5000];                % [Ch0 Ch1] dynamic range in mV
chIM       = [1 0];                     % channel input impedance, 1 - 50Ohm, 0 - 1MOhm
TrigType   = 1;                         % if 1 then external trig is used, internal all else 
                                             
daqStSingleAq(aqInt,noChannels,fs,chDR,chIM,TrigType); % check card is powered and connected!

%global cardInfo

%% Aqu settings for CW exposures

nCyc = 330000;  % No of cycles, every 10Hz (laser rep rate)
f0   = 3.3E6;   % freq
dur  = 10;       % exposure time
PrPs = 1;       % pre and post acq time
dV   = 190;      % mV function generator drive setting 
Na   = round((dur + 2*PrPs)/0.1);

expName = '210713_HIFU_test';
%% Run exposures
    
fnSetVolt(dV*1E-3);pause(0.1); % set voltage on function generator
fnSetBcnt(nCyc);pause(0.1);    % set burst count on function generator

input('Ready (amp on)?');

for j = 1:length(expPOS)
    
    tic
    pcdDat = zeros(cardInfo.setMemsize,Na);
    vltDat = zeros(cardInfo.setMemsize,Na);
    pos    = LS3move(expPOS(j,1),expPOS(j,2),expPOS(j,3),25,0.1);
    name   = [expName '_POS' num2str(j)]; %set filename for saving
   
    disp(['Xpos: ' num2str(expPOS(j,1)) 'mm, Ypos:' num2str(expPOS(j,2)) 'mm, Zpos: ' num2str(expPOS(j,3)) 'mm'])
    disp(['Drive: ' num2str(dV) 'mV, Start!']);
    QCrun
    disp(['Exposure ' num2str(j) ' of ' num2str(length(expPOS))]);
    
    for i = 1:Na      
        if ((PrPs/0.1) == i)
            fnOn % turn on function generator
            disp('HIFU On!');
        end

        [t,DAT]     = daqSAqu; % aquire data
        pcdDat(:,i) = DAT(:,1);
        vltDat(:,i) = DAT(:,2);

        if (((dur+PrPs)/0.1) == i)
            fnOff % turn off function generator
            disp('HIFU Off');
        end

    end
    disp('Stop');
    fnOff
   
    disp('Saving...');
    %pos = LS3move(12.5,12.5,25,25,0.1); % comment out when doing more than 1 exposure. 
    save([name '.mat'],'pcdDat','vltDat','t','f0','fs','dur','PrPs','dV','expPOS');
    toc
end

fnSetBcnt(5);
QCstop

pos = LS3move(12.5,12.5,25,25,0.1); % move stage out of the way
disp('Turn on pump/vac');
%%

daqEnSingleAq
QCclose
fnClose




