% Beamplotting software for UARP arrays with point (wire) source
% Using Agilent Scope, connected via ModeNet

% James Mclaughlan
% Dec 2019

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

%scope = ULab.Scope.KEYSIGHT_SCOPE('scope', 'tcp4', '192.168.42.100');

%% CNC position for focal point

cncFocus = [-40, 130, -220]; % this is usually pre-aligned

%% Set scan ranges and data Aqu

xScanRange = [-3 3] + cncFocus(1); % in mm range centred on cncFocus;
yScanRange = (-20:0.5:20) + cncFocus(2); % in mm range centred on cncFocus;
zScanRange = (-10:1:30) + cncFocus(3); % in mm range centred on cncFocus;
dat        = scope.downloadData('segments', 'all'); % downloads what's on the scope, just to get buffer length
nLength    = dat.Waveforms(1).NPoints; % gets buffer length for displayed data on Agilent Scope
clear dat;

pData = zeros(nLength,length(yScanRange),length(zScanRange)); % all pressure data (Ch2)
vData = zeros(nLength,length(yScanRange),length(zScanRange)); % all drive voltage data (Ch1)
pPP   = zeros(length(yScanRange),length(zScanRange)); % peak positive pressure
pNP   = zeros(length(yScanRange),length(zScanRange)); % peak negative pressure

%hydroCal = 0.337; %V/MPa at 2MHz from calibration sheet 

fileName = '191205_Wire_YZ_el';

figure(1);figure(2);figure(3)

%% Peform Scan
input('Ready?');
for k = 1:length(xScanRange)
for i=1:length(zScanRange)
    for j=1:length(yScanRange)
        
        disp([num2str(xScanRange(k)) 'mm, ' num2str(yScanRange(j)) 'mm, ' num2str(zScanRange(i)) 'mm'])
        CNC_MovePositionLinear(  xScanRange(k), yScanRange(j), zScanRange(i), 0, true);
        pause(1);
        scope.clear
        pause(1);       
        
        dat = scope.downloadData('segments', 'all');

        vData(:,j,i) = dat.Waveforms(1).Buffers.AmplitudeData{1};
        pData(:,j,i) = HydrophoneInverseFilter(dat.Waveforms(2).Buffers.AmplitudeData{1},1/dat.Waveforms(1).XIncrement,3);
        pPP(j,i)     = max(pData(15000:end,j,i));
        pNP(j,i)     = abs(min(pData(15000:end,j,i)));
               
        figure(1);plot(dat);drawnow;
        figure(2);imagesc(yScanRange,zScanRange,pPP);colorbar;drawnow;
        figure(3);imagesc(yScanRange,zScanRange,pNP);colorbar;drawnow;
        
    end
end

tData = dat.Waveforms(2).TimeData;
CNC_MovePositionLinear(  cncFocus(1), cncFocus(2), cncFocus(3), 0, true);
disp('Saving...');
save([fileName num2str(xScanRange(k)) '.mat'],'vData','pData','pPP','pNP','tData','xScanRange','yScanRange','zScanRange');

end

%% Close hardware

% Park CNC system
CNC_MovePosition(0,0,100,0,true);

disp('Apply clamps to vertical (Z) axis. Then press any key to continue.')
pause
 
CNC_DisableDrives();

CNC_CloseConnection();











