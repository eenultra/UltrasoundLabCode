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
%% Agilent Sig Gen configure
sg = ULab.SigGen.KEYSIGHT_3360xx('FunctionGenerator', 'TCP4', '192.168.42.106');

% Waveform config
sg.Function = 'sin';
sg.Frequency = 3.3e6;
sg.Amplitude = 0.025; %% DO NOT EXCEED 480mV!
sg.Offset = 0;
sg.Phase = 0;

% Burst config
sg.Burst_Enabled = true;
sg.Burst_Cycles = 30;
sg.Burst_Mode = 'Triggered';

% Upload parameters
sg.configure;

% Enable output (configure disables output automatically)
sg.disable;

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

fName = '200219_3p3MHz_H102i_R1';

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

            scope.clear
            pause(0.5);       

            sg.enable;
            pause(1);
            dat = scope.downloadData('segments', 'all');
            sg.disable;

            vData(:,j,i) = dat.Waveforms(1).Buffers.AmplitudeData{1};
            pData(:,j,i) = HydrophoneInverseFilter(dat.Waveforms(2).Buffers.AmplitudeData{1},1/dat.Waveforms(1).XIncrement,2);
            %pData(:,j,i) = dat.Waveforms(2).Buffers.AmplitudeData{1}/hydroCal;
            pPP(j,i)     = max(pData(5000:end,j,i));
            pNP(j,i)     = abs(min(pData(5000:end,j,i)));

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











