% Beamplotting software for HIFU transducers and Power Amp
% Using Agilent Scope and function gen, connected via ModeNet

% James Mclaughlan
% Oct 2019

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

CNC_OpenConnection('COM8');
CNC_EnableDrives();

CNC_Home();
CNC_Status();
disp(['Current Position: ' num2str(CNC_CurrentPosition()) '     Commanded Position: ' num2str(CNC_CommandedPosition())])

scope      = ULab.Scope.KEYSIGHT_SCOPE('scope', 'tcp4', '192.168.42.111');
%% Initialise UConfig
% This section clears any existing UARP configurations, and creates a new
% blank UARP configuration with the right simulated hardware for this demo.
UARP.init('HIFUARP');

% Initialise Platform Hardware
UConfig.initialiseHardware();

% Define Logical Transducer
UConfig.newTransducer('H_102', UConfig.Library.Transducer.H_102, 'Sx0002.5');

% Create Procedure

UConfig.newProcedure('expose');

% Number of times to repeat whole procedure.
UConfig.expose.NTimes = 20;

% How to download receive data back from the UARP.
UConfig.expose.DownloadMode = UARP.Constant.DownloadMode.Disabled;

% Set up procedure triggering.
UConfig.expose.Trigger.InMode = 'Internal';
UConfig.expose.Trigger.InPolarity = 'RisingEdge';

% Create Operation
UConfig.expose.newOperation('CW', 'Sequential');

% Repeat the overarching procedure the number of times you want the
% operation to execute with callback.
%  UConfig.expose.NTimes = 7;
%  UConfig.expose.CW.ExecuteCallback = @performHIFUMove;
%  UConfig.expose.CW.Trigger.Period = 1;

% Create Scan
UConfig.expose.CW.newScan('HIFUScan', UConfig.H_102, 'Plane', 'Segmented');

% Core Scan Properties
UConfig.expose.CW.HIFUScan.FirstElement = 1;
UConfig.expose.CW.HIFUScan.LastElement = 1;
UConfig.expose.CW.HIFUScan.NTimes = 1;
UConfig.expose.CW.HIFUScan.SpeedOfSound = 1480;

% Transmit Properties
% A ten second duration is much longer than waveform memory! Using this
% mode we can excite for HIFU 

UConfig.expose.CW.HIFUScan.Transmit.Amplitude = 0.4;
UConfig.expose.CW.HIFUScan.Transmit.CentralFrequency = 1.1E6;
UConfig.expose.CW.HIFUScan.Transmit.Duration = 10/UConfig.expose.CW.HIFUScan.Transmit.CentralFrequency; % time as a function of no cycles

% Ramp up and ramp down slowly changes the amplitude from 0 to the max
% amplitude outlined above over a number of waveform cycles. The default
% number is four, but this shows how we can increase ramp up to 6 and
% reduce ramp down to none.
UConfig.expose.CW.HIFUScan.Transmit.RampUpCycles = 6;
UConfig.expose.CW.HIFUScan.Transmit.RampDownCycles = 0;

% No Receive Properties as this is transmit only
UConfig.expose.CW.HIFUScan.Receive.Enabled = false;

% PSU Properties
UConfig.expose.CW.HIFUScan.PSU.Enabled = true;
UConfig.expose.CW.HIFUScan.PSU.Voltages = [-72 -36 36 72];
UConfig.expose.CW.HIFUScan.PSU.Currents = [0.315, 0.315, 0.315, 0.315];

% Calculate Procedure Data
UConfig.expose.calculateData();

% Configure UARP Hardware
UConfig.expose.configureHardware();

%% CNC position for focal point

cncFocus = [65,135,-190]; % this is usually pre-aligned

%% Scope config
dat        = scope.downloadData('segments', 'all'); % downloads what's on the scope, just to get buffer length
nLength    = dat.Waveforms(1).NPoints; % gets buffer length for displayed data on Agilent Scope
clear dat;

%% Set scan ranges and data Aqu

aScanRange = (-5:0.25:5); % in mm range;
bScanRange = (-10:0.5:10); % in mm range; 

%hydroCal = 0.353; %V/MPa at 3.3MHz from calibration sheet 

fName = '210217_1p1MHz_H102i_HIFUARP';

figure(1);figure(2);figure(3)

%% Peform Scan

plane = ['XZ';'YZ'];
sPlane = size(plane);

input('Ready?');
for k = 1:sPlane(1)
    
    pData = zeros(nLength,length(bScanRange),length(aScanRange)); % all pressure data (Ch2)
    vData = zeros(nLength,length(bScanRange),length(aScanRange)); % all drive voltage data (Ch1)
    pPP   = zeros(length(bScanRange),length(aScanRange)); % peak positive pressure
    pNP   = zeros(length(bScanRange),length(aScanRange)); % peak negative pressure
    
    for i=1:length(aScanRange)
        for j=1:length(bScanRange)
            scope.clear

            if strcmp(plane(k,:),'XY') == 1
            disp([num2str(bScanRange(j)+cncFocus(1)) 'mm, ' num2str(aScanRange(i)+cncFocus(2)) 'mm, ' num2str(cncFocus(3)) 'mm'])     
            CNC_MovePositionLinear(bScanRange(j)+cncFocus(1), aScanRange(i)+cncFocus(2), cncFocus(3), 0, true);  
            fileName = [fName '_XY'];
            elseif strcmp(plane(k,:),'YZ') == 1
            disp([num2str(cncFocus(1)) 'mm, ' num2str(aScanRange(i)+cncFocus(2)) 'mm, ' num2str(bScanRange(j)+cncFocus(3)) 'mm'])     
            CNC_MovePositionLinear(cncFocus(1), aScanRange(i)+cncFocus(2), bScanRange(j)+cncFocus(3), 0, true);  
            fileName = [fName '_YZ'];
            elseif strcmp(plane(k,:),'XZ') == 1
            disp([num2str(cncFocus(1)) 'mm, ' num2str(aScanRange(i)+cncFocus(2)) 'mm, ' num2str(bScanRange(j)+cncFocus(3)) 'mm'])     
            CNC_MovePositionLinear(aScanRange(i)+cncFocus(1), cncFocus(2), bScanRange(j)+cncFocus(3), 0, true);  
            fileName = [fName '_XZ'];
            end

            pause(0.5);       
            UConfig.expose.psuEnable();
           % This function actually executes the procedure on the UARP.
            UConfig.expose.execute();
           % Power-supplies will be turned off automatically at the end of the execute
           % function. But we can also do it here to be doubly sure.
            UConfig.expose.psuDisable();
            dat = scope.downloadData('segments', 'all');

            vData(:,j,i) = dat.Waveforms(1).Buffers.AmplitudeData{1};
            pData(:,j,i) = HydrophoneInverseFilter(dat.Waveforms(2).Buffers.AmplitudeData{1},1/dat.Waveforms(1).XIncrement,2);
            %pData(:,j,i) = dat.Waveforms(2).Buffers.AmplitudeData{1}/hydroCal;
            pPP(j,i)     = max(pData(13000:end,j,i));
            pNP(j,i)     = abs(min(pData(13000:end,j,i)));

            figure(1);plot(dat);drawnow;
            figure(2);imagesc(aScanRange,bScanRange,pPP/1E6);title('PPP');colorbar;drawnow;
            figure(3);imagesc(aScanRange,bScanRange,pNP/1E6);title('PNP');colorbar;drawnow;

        end
    end

tData = dat.Waveforms(2).TimeData;
%Move hydrophone to a safe position in case TXD drops.
CNC_MovePositionLinear(65, 50, -190, 0, true);
disp('Saving...');
save([fileName '.mat'],'vData','pData','pPP','pNP','tData','aScanRange','bScanRange','cncFocus','-v7.3');
clear pData pPP pNP vData;
end

%% Close hardware

% Park CNC system
CNC_MovePosition(0,0,100,0,true);

disp('Apply clamps to vertical (Z) axis. Then press any key to continue.')
pause
 
CNC_DisableDrives();

CNC_CloseConnection();











