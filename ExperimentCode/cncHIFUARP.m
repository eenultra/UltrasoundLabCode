% Beamplotting software for HIFU transducers and HIFUARP
% Using Agilent Scope, connected via ModeNet

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

CNC_OpenConnection('COM6');
CNC_EnableDrives();

CNC_Home();
CNC_Status();
disp(['Current Position: ' num2str(CNC_CurrentPosition()) '     Commanded Position: ' num2str(CNC_CommandedPosition())])

%% CNC position for focal point

cncFocus = [110, 300, 30]; % this is usually pre-aligned

%% Set scan ranges and data Aqu

xScanRange = (-10:0.5:10) + cncFocus(1); % in mm range centred on cncFocus;
yScanRange = (-10:0.5:10) + cncFocus(2); % in mm range centred on cncFocus;
zScanRange = cncFocus(3); % in mm range centred on cncFocus;
dat        = scope.downloadData('segments', 'all'); % downloads what's on the scope, just to get buffer length
nLength    = dat.Waveforms(1).NPoints; % gets buffer length for displayed data on Agilent Scope
clear dat;

pData = zeros(nLength,length(xScanRange),length(yScanRange)); % all pressure data (Ch2)
vData = zeros(nLength,length(xScanRange),length(yScanRange)); % all drive voltage data (Ch1)
pPP   = zeros(length(xScanRange),length(yScanRange)); % peak positive pressure
pNP   = zeros(length(xScanRange),length(yScanRange)); % peak negative pressure

hydroCal = 0.337; %V/MPa at 2MHz from calibration sheet 

fileName = '190926_IM10_50pc_2PiPhaseWob_XYscan';

figure(1);figure(2);figure(3)

%% Peform Scan
input('Ready?');

for i=1:length(yScanRange)
    for j=1:length(xScanRange)
        scope.clear
        disp([num2str(xScanRange(j)) 'mm, ' num2str(yScanRange(i)) 'mm, ' num2str(zScanRange) 'mm'])
        CNC_MovePositionLinear(  xScanRange(j), yScanRange(i), zScanRange, 0, true);
        pause(0.5);       
        % Run Procedure on HIFUARP - This will use the preconfigured parameters
        % must be changed in config code
        % We then enable high-voltage PSUs for all systems used by the procedure.
        UConfig.PulseProcedure.psuEnable();
        % This function actually executes the procedure on the UARP.
        UConfig.PulseProcedure.execute();
        % Power-supplies will be turned off automatically at the end of the execute
        % function. But we can also do it here to be doubly sure.
        UConfig.PulseProcedure.psuDisable();
        
        dat = scope.downloadData('segments', 'all');

        vData(:,j,i) = dat.Waveforms(1).Buffers.AmplitudeData{1};
        pData(:,j,i) = dat.Waveforms(2).Buffers.AmplitudeData{1}/hydroCal;
        pPP(j,i)     = max(pData(15000:end,j,i));
        pNP(j,i)     = abs(min(pData(15000:end,j,i)));
               
        figure(1);plot(dat);drawnow;
        figure(2);imagesc(yScanRange,xScanRange,pPP);colorbar;drawnow;
        figure(3);imagesc(yScanRange,xScanRange,pNP);colorbar;drawnow;
        
    end
end

tData = dat.Waveforms(2).TimeData;
CNC_MovePositionLinear(  cncFocus(1), cncFocus(2), cncFocus(3), 0, true);
disp('Saving...');
save([fileName '.mat'],'vData','pData','pPP','pNP','tData','UConfig','xScanRange','yScanRange','zScanRange');

%% Close hardware

% Park CNC system
CNC_MovePosition(0,0,100,0,true);

disp('Apply clamps to vertical (Z) axis. Then press any key to continue.')
pause
 
CNC_DisableDrives();

CNC_CloseConnection();











