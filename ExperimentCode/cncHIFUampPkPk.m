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

scope      = ULab.Scope.KEYSIGHT_SCOPE('scope', 'tcp4', '192.168.42.100');
%% Agilent Sig Gen configure
sg = ULab.SigGen.KEYSIGHT_3360xx('FunctionGenerator', 'TCP4', '192.168.42.106');

% Waveform config
sg.Function = 'sin';
sg.Frequency = 3.3e6;
sg.Amplitude = 0.025;
sg.Offset = 0;
sg.Phase = 0;
sg.Arbitrary_WaveformName = ['Tom' 'Harry'];

% Burst config
sg.Burst_Enabled = true;
sg.Burst_Cycles = 10;
sg.Burst_Mode = 'Triggered';

% Upload parameters
sg.configure;

% Enable output (configure disables output automatically)
sg.disable;

%% CNC position for focal point
cncFocus = [-20, 320, 40]; % this is usually pre-aligned

%% Scope config
dat        = scope.downloadData('segments', 'all'); % downloads what's on the scope, just to get buffer length
nLength    = dat.Waveforms(1).NPoints; % gets buffer length for displayed data on Agilent Scope
clear dat;

%% Set scan ranges and data Aqu

sg.Frequency = 3.3e6; % drive frequency
hydroCal = 0.353; %V/MPa at 2MHz from calibration sheet 
dV       = 25:25:350; % mV drive range for Agilent
Run      = 3; % number of repeats
fileName = '191030_3p3MHz_H102-98_25-350mV'; %saved file name

figure(1);figure(2);

%% Peform Measurement

input('Ready?');
    
    pData = zeros(nLength,length(dV),Run); % all pressure data (Ch2)
    vData = zeros(nLength,length(dV),Run); % all drive voltage data (Ch1)
    pPP   = zeros(length(dV),Run); % peak positive pressure
    pNP   = zeros(length(dV),Run); % peak negative pressure
    
    for i=1:Run
        for j=1:length(dV)
            sg.Amplitude = dV(j)*1E-3; % !!PLEASE ENSURE CORRECT VOLTAGE IS SUPPLIED, DO NOT EXCEED 450mVpk OR YOU WILL DAMAGE AMP!!           
            
            if sg.Amplitude >= 0.48
                disp('Voltage Too High!!!');
                break
            else
                sg.configure
            end
            
            scope.clear;
            sg.enable;
            pause(1);
            dat = scope.downloadData('segments', 'all');
            sg.disable;        
            vData(:,j,i) = dat.Waveforms(1).Buffers.AmplitudeData{1};
            %pData(:,j,i) = HydrophoneInverseFilter(dat.Waveforms(2).Buffers.AmplitudeData{1},1/dat.Waveforms(1).XIncrement,2);
            pData(:,j,i) = dat.Waveforms(2).Buffers.AmplitudeData{1}/hydroCal;
            pPP(j,i)     = max(pData(135000:150000,j,i));
            pNP(j,i)     = abs(min(pData(135000:150000,j,i)));%%%135000:150000

            figure(1);plot(dat);drawnow;
            figure(2);plot(dV,pPP,'.b',dV,pNP,'xr');drawnow;

        end
    end

tData = dat.Waveforms(2).TimeData;
disp('Saving...');
save([fileName '.mat'],'vData','pData','pPP','pNP','tData','dV','cncFocus','-v7.3');

%% Close hardware

% Park CNC system
CNC_MovePosition(0,0,100,0,true);

disp('Apply clamps to vertical (Z) axis. Then press any key to continue.')
pause
 
CNC_DisableDrives();

CNC_CloseConnection();











