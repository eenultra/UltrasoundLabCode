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

CNC_OpenConnection('COM6');
CNC_EnableDrives();

CNC_Home();
CNC_Status();
disp(['Current Position: ' num2str(CNC_CurrentPosition()) '     Commanded Position: ' num2str(CNC_CommandedPosition())])

scope      = ULab.Scope.KEYSIGHT_SCOPE('scope', 'tcp4', '192.168.42.100');
%% Agilent Sig Gen configure
sg = ULab.SigGen.KEYSIGHT_3360xx('FunctionGenerator', 'TCP4', '192.168.42.106');

% Waveform config
sg.Function = 'sin';
sg.Frequency = 1.1e6;
sg.Amplitude = 0.150; %% DO NOT EXCEED 480mV!
sg.Offset = 0;
sg.Phase = 0;

% Burst config
sg.Burst_Enabled = true;
sg.Burst_Cycles = 10;
sg.Burst_Mode = 'Triggered';

% Upload parameters
sg.configure;

% Enable output (configure disables output automatically)
sg.disable;

%% CNC position for focal point

cncFocus = [2, 297, 30.5]; % this is usually pre-aligned

%% Scope config
dat        = scope.downloadData('segments', 'all'); % downloads what's on the scope, just to get buffer length
nLength    = dat.Waveforms(1).NPoints; % gets buffer length for displayed data on Agilent Scope
clear dat;

%% Set scan ranges and data Aqu

aScanRange = (-10:0.5:10); % in mm range;
bScanRange = (-5:0.2:5); % in mm range; 

hydroCal = 0.353; %V/MPa at 3.3MHz from calibration sheet 

fName = '281024_1p1MHz_150mV_6MPa_H102';

figure(1);figure(2);figure(3)

%% Peform Scan

plane = ['XY';'YZ'];
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
            end

            pause(0.5);       

            sg.enable;
            pause(1);
            dat = scope.downloadData('segments', 'all');
            sg.disable;

            vData(:,j,i) = dat.Waveforms(1).Buffers.AmplitudeData{1};
            %pData(:,j,i) = HydrophoneInverseFilter(dat.Waveforms(2).Buffers.AmplitudeData{1},1/dat.Waveforms(1).XIncrement,2);
            pData(:,j,i) = dat.Waveforms(2).Buffers.AmplitudeData{1}/hydroCal;
            pPP(j,i)     = max(pData(50000:end,j,i));
            pNP(j,i)     = abs(min(pData(50000:end,j,i)));

            figure(1);plot(dat);drawnow;
            figure(2);imagesc(bScanRange,aScanRange,pPP);title('PPP');colorbar;drawnow;
            figure(3);imagesc(bScanRange,aScanRange,pNP);title('PNP');colorbar;drawnow;

        end
    end

tData = dat.Waveforms(2).TimeData;
CNC_MovePositionLinear(  cncFocus(1), cncFocus(2), cncFocus(3), 0, true);
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











