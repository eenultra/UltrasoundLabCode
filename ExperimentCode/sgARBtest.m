%ARB setup
fc  = 3.3E6; % centre freq of HIFU
nCy = 40; 

nPI     = 2*nCy;
vLength = round((sRate/fc)*nCy);
sLength = 10*round((sRate/fc));
sRate   = 500E6; % sampleRate of 500 MS/s set of sig gen
v       = sin(linspace(0,nPI*pi,vLength)).*tukeywin(vLength,0)'; %sin pulse
X       = [];%zeros(1,sLength); % samples between pulses 
b       = [v,X,-v]; % combined v with inverted v, with space X

sg.arbitraryUpload('sintest', b);

% sg.Function = 'arb';
% %sg.SampleRate = sRate;
 sg.Amplitude = 0.025; %% DO NOT EXCEED 480mV!
% sg.Offset = 0;
% %sg.Phase = 0;
% 
% % Burst config
% sg.Burst_Enabled = true;
 sg.Burst_Cycles = 1;
% sg.Burst_Mode = 'Triggered';
% 
% % Upload parameters
 sg.configure;
% 
% % Enable output (configure disables output automatically)
% sg.disable;


%%

fName = '3p3MHz_Pi_Shift';

dat   = scope.downloadData('segments', 'all');
pData = HydrophoneInverseFilter(dat.Waveforms(2).Buffers.AmplitudeData{1},1/dat.Waveforms(1).XIncrement,2);
vData = dat.Waveforms(1).Buffers.AmplitudeData{1};
tData = dat.Waveforms(2).TimeData;

figure(1); plot(tData*1E6,pData/1E6,'r');xlabel('Time (\mus)');ylabel('Pressure (MPa)');
figure(2); plot(tData*1E6,vData);xlabel('Time (\mus)');ylabel('Voltage (V)');

save([fName '.mat'],'tData','pData','vData','dat','v','sRate','b','X');

