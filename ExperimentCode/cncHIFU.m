% Beamplotting software for HIFU transducers and Power amps
% Using Pico USB scope for aqui

% James Mclaughlan
% Jun 2019

%% Init hardware

global CNC 

% General CNC defaults
CNC.SoftwareLimits.X.Values = [0 0];
CNC.SoftwareLimits.X.Enabled = false;
CNC.SoftwareLimits.Y.Values = [0 0];
CNC.SoftwareLimits.Y.Enabled = false;
CNC.SoftwareLimits.Z.Values = [0 0];
CNC.SoftwareLimits.Z.Enabled = false;
CNC.SoftwareLimits.R.Values = [-380 380]; 
CNC.SoftwareLimits.R.Enabled = false;

disp('Initializing CNC...') 

CNC_OpenConnection('COM3');
CNC_EnableDrives();

CNC_Home();
CNC_Status();
disp(['Current Position: ' num2str(CNC_CurrentPosition()) '     Commanded Position: ' num2str(CNC_CommandedPosition())])

agopen         % check the COM port, usually COM4 using RS232 - USB cable
agoff
f0 = 1.1E6; % freq of transducer;
mV = 50E-3; % mV setting on Agilent;
agSetFreq(f0);agSetVolt(mV);

%% Manual transducer align
% use the Pico software with and CNC to get the HIFU transducer aligned to
% the focal point.
c = 1496; %m/s for 25oC, which is what the tank typicall is after recirc
% CNC_MovePositionLinear(x,y,z, 0 ,false); find focal point using this

%focal point x,y,z coordinates
x1 = 30;
y1 = 150;
z1 = -157;

%% Config PicoScope

picoStart;
% CHECK Pico Config before running
picoConfig; 


%% Set scan ranges and data Aqu

xRes = 0.25; % mm
yRes = 0.5;   % mm
zRes = 0.25; % mm

% mm, scan range used for axis
xScanRange = 0;             xFlag = 0; %-10:xRes:10;
yScanRange = -50:yRes:30;   yFlag = 1; %-20:yRes:10; 
zScanRange = -10:xRes:10;   zFlag = 1; % -6:zRes:6;
%Flag is to define scan plane below, XY,XZ,YZ

% mm, convert to points to scan around pre-defined focal region
xScanPoints = xScanRange + x1;
yScanPoints = yScanRange + y1;
zScanPoints = zScanRange + z1;

%displays start/stop points for the three axis to ensure no crashes!
disp(['Start/End points for, x= ' num2str(xScanPoints(1)) ' mm, ' num2str(xScanPoints(end)) ' mm']);
disp(['Start/End points for, y= ' num2str(yScanPoints(1)) ' mm, ' num2str(yScanPoints(end)) ' mm']);
disp(['Start/End points for, z= ' num2str(zScanPoints(1)) ' mm, ' num2str(zScanPoints(end)) ' mm']);

%CNC_MovePositionLinear(x,y,z, 0 ,true) check points manually before
%proceeding. 

CNC_Status();
disp(' ');
disp(['Current Position: ' num2str(CNC_CurrentPosition()) ' mm']);

% Define Data
scanData = squeeze(zeros(length(xScanPoints),length(yScanPoints),length(zScanPoints),nMaxSamp));
pppMap = squeeze(zeros(length(xScanPoints),length(yScanPoints),length(zScanPoints)));
pnpMap = squeeze(zeros(length(xScanPoints),length(yScanPoints),length(zScanPoints)));

hydroCal = 343; % for membrane 343mV/MPa @ 1MHz, 349 mV/MPa @ 3MHz

%% Movement Check

datName = '190619_H102-98_R1_';
str = input('Have you checked that the Transducer/Hydrophone can move safelty in this range? [y/n] ','s');

if str == 'y'
    % Peform Scan
    picoShow = 0; % does not display data from picoGrab
    %Define 2D scan plane
        if (xFlag == 1 && yFlag == 0 && zFlag == 1)
            disp('Scanning XZ plane');
            iRange = xScanPoints;jRange = zScanPoints;
            datName = [datName 'XZ'];
        elseif (xFlag == 1 && yFlag == 1 && zFlag == 0)
            disp('Scanning XY plane');
            iRange = xScanPoints;jRange = yScanPoints;
            datName = [datName 'XY'];
        elseif (xFlag == 0 && yFlag == 1 && zFlag == 1)
            disp('Scanning YZ plane');
            iRange = yScanPoints;jRange = zScanPoints;
            datName = [datName 'YZ'];
        else
            return
        end
        
   % switch on ultrasound and start scanning     
    agon
        for i=1:length(iRange)
            for j=1:length(jRange)
                
            if (xFlag == 1 && yFlag == 0 && zFlag == 1)
                CNC_MovePositionLinear(iRange(i),y1,jRange(j), 0 ,true);
            elseif (xFlag == 1 && yFlag == 1 && zFlag == 0)
                CNC_MovePositionLinear(iRange(i),jRange(j),z1, 0 ,true);
            elseif (xFlag == 0 && yFlag == 1 && zFlag == 1)
                CNC_MovePositionLinear(x1,iRange(i),jRange(j), 0 ,true);
            end
                picoGrab;pause(0.1);
                scanData(i,j,:) = mean(chA,2)/hydroCal;
                pppMap(i,j)     = max(mean(chA,2))/hydroCal;
                pnpMap(i,j)     = abs(min(mean(chA,2)))/hydroCal;
                clear chA;
                
                figure(1);plot(timeNs/1E3,squeeze(scanData(i,j,:)));drawnow
                figure(2);plot(timeNs/1E3,mean(chB,2));drawnow
                figure(3);imagesc(iRange,jRange,pnpMap);colormap;drawnow
            end
        end
    agoff
    
    disp('saving data....');
    save([datName '.mat'],'xScanPoints','yScanPoints','zScanPoints','x1','y1','z1','f0','mV','pppMap','pnpMap','scanData','hydroCal','c','timeNs', 'chB');
end

CNC_MovePosition(x1,y1,z1,0,true); %return to focus position

%% Close hardware

agclose
picoStop

% Park CNC system
CNC_MovePosition(0,0,100,0,true);

disp('Apply clamps to vertical (Z) axis. Then press any key to continue.')
pause
 
CNC_DisableDrives();

CNC_CloseConnection();











