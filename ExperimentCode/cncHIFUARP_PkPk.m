% Peak pressure measurement software for HIFU transducers and Power Amp
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

CNC_OpenConnection('COM6');
CNC_EnableDrives();

CNC_Home();
CNC_Status();
disp(['Current Position: ' num2str(CNC_CurrentPosition()) '     Commanded Position: ' num2str(CNC_CommandedPosition())])

scope      = ULab.Scope.KEYSIGHT_SCOPE('scope', 'tcp4', '192.168.42.111');
%% HIFUARP configure

% Initialise UConfig
% This section clears any existing UARP configurations, and creates a new
% blank UARP configuration with the right simulated hardware for this demo.
UARP.init('HIFUARP');

% Initialise Platform Hardware
UConfig.initialiseHardware();

% Define Logical Transducer

UConfig.newTransducer('H_102', UConfig.Library.Transducer.H_102, 'Sx0002.5');

% Create Procedure

UConfig.newProcedure('PulseProcedure');
% Number of times to repeat whole procedure.
UConfig.PulseProcedure.NTimes = 20;

% How to download receive data back from the UARP.
UConfig.PulseProcedure.DownloadMode = UARP.Constant.DownloadMode.Disabled;

% Set up procedure triggering.
UConfig.PulseProcedure.Trigger.InMode = 'Internal';
UConfig.PulseProcedure.Trigger.InPolarity = 'RisingEdge';

% Create Operation
UConfig.PulseProcedure.newOperation('TenCyclePulse', 'Sequential');

% Create Scan
UConfig.PulseProcedure.TenCyclePulse.newScan('Scan1', UConfig.H_102, 'Plane', 'Segmented');

%% CNC position for focal point
cncFocus = [65, 135, -190]; % this is usually pre-aligned

%% Scope config
dat        = scope.downloadData('segments', 'all'); % downloads what's on the scope, just to get buffer length
nLength    = dat.Waveforms(1).NPoints; % gets buffer length for displayed data on Agilent Scope
clear dat;

%% Set scan ranges and data Aqu
POW      = 0.1:0.1:0.8; % percent of HIFUARP power 0.1-1
Run      = 3; % number of repeats
fileName = '200218_1p1MHz_H102m_HIFUARP'; %saved file name

figure(1);figure(2);

%% Peform Measurement

input('Ready?');
    
    pData = zeros(nLength,length(POW),Run); % all pressure data (Ch2)
    vData = zeros(nLength,length(POW),Run); % all drive voltage data (Ch1)
    pPP   = zeros(length(POW),Run); % peak positive pressure
    pNP   = zeros(length(POW),Run); % peak negative pressure
    
    for i=1:Run
        for j=1:length(POW)

        % Core Scan Properties
        UConfig.PulseProcedure.TenCyclePulse.Scan1.FirstElement = 1;
        UConfig.PulseProcedure.TenCyclePulse.Scan1.LastElement = 1;
        UConfig.PulseProcedure.TenCyclePulse.Scan1.NTimes = 1;
        UConfig.PulseProcedure.TenCyclePulse.Scan1.SpeedOfSound = 1480;

        % Transmit Properties
        % A ten second duration is much longer than waveform memory! Using this
        % mode we can excite for HIFU 
        UConfig.PulseProcedure.TenCyclePulse.Scan1.Transmit.Amplitude = POW(j);
        UConfig.PulseProcedure.TenCyclePulse.Scan1.Transmit.CentralFrequency = 1.1E6;
        UConfig.PulseProcedure.TenCyclePulse.Scan1.Transmit.Duration = 10/(UConfig.PulseProcedure.TenCyclePulse.Scan1.Transmit.CentralFrequency);

        % Ramp up and ramp down slowly changes the amplitude from 0 to the max
        % amplitude outlined above over a number of waveform cycles. The default
        % number is four, but this shows how we can increase ramp up to 6 and
        % reduce ramp down to none.
        UConfig.PulseProcedure.TenCyclePulse.Scan1.Transmit.RampUpCycles = 6;
        UConfig.PulseProcedure.TenCyclePulse.Scan1.Transmit.RampDownCycles = 0;

        % No Receive Properties as this is transmit only
        UConfig.PulseProcedure.TenCyclePulse.Scan1.Receive.Enabled = false;

        % PSU Properties
        UConfig.PulseProcedure.TenCyclePulse.Scan1.PSU.Enabled = true;
        UConfig.PulseProcedure.TenCyclePulse.Scan1.PSU.Voltages = [-72 -36 36 72];
        UConfig.PulseProcedure.TenCyclePulse.Scan1.PSU.Currents = [0.315 0.315 0.315 0.315];

        % Calculate Procedure Data
        % Some property validation takes place whenever a property has a new value
        % set. However, there is much more that needs to be done to turn a scan
        % into experiment data the UARP understands. That is achieved as follows.
        %
        % As was descirbed earlier, a procedure is the single unit of information
        % that can be uploaded to the UARP at once. Hence, procedure calls the next
        % functions.
        UConfig.PulseProcedure.calculateData();


        % Configure UARP Hardware
        % The hardware of the UARP then needs configuring. We must uploads the
        % procedure configuration to UARP devices, disable PSUs, then configure
        % voltage/current settings.
        UConfig.PulseProcedure.configureHardware();

          
        scope.clear;pause(0.1);

           % Run Procedure on HIFUARP - This will use the preconfigured parameters
           % must be changed in config code
           % We then enable high-voltage PSUs for all systems used by the procedure.
        UConfig.PulseProcedure.psuEnable();
           % This function actually executes the procedure on the UARP.
        UConfig.PulseProcedure.execute();
           % Power-supplies will be turned off automatically at the end of the execute
           % function. But we can also do it here to be doubly sure.
        UConfig.PulseProcedure.psuDisable();
           
        pause(0.1);
        dat = scope.downloadData('segments', 'all');
        
        vData(:,j,i) = dat.Waveforms(1).Buffers.AmplitudeData{1};
        pData(:,j,i) = HydrophoneInverseFilter(dat.Waveforms(2).Buffers.AmplitudeData{1},1/dat.Waveforms(1).XIncrement,2);
            %pData(:,j,i) = dat.Waveforms(2).Buffers.AmplitudeData{1}/hydroCal;
        pPP(j,i)     = max(pData(20000:22500,j,i));
        pNP(j,i)     = abs(min(pData(20000:23000,j,i)));%%%135000:150000

        figure(1);plot(dat);drawnow;
        figure(2);plot(POW,pPP/1E6,'.b',POW,pNP/1E6,'xr');drawnow;

        end
    end

tData = dat.Waveforms(2).TimeData;
disp('Saving...');
save([fileName '.mat'],'vData','pData','pPP','pNP','tData','POW','cncFocus','-v7.3');

%% Close hardware

% Park CNC system
CNC_MovePosition(0,0,100,0,true);

disp('Apply clamps to vertical (Z) axis. Then press any key to continue.')
pause
 
CNC_DisableDrives();

CNC_CloseConnection();











