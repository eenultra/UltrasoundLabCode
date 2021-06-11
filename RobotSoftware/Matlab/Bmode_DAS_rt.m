global UConfig

UARP_RAW_DATA = double(UConfig.Procedure1.Operation1.Scan1.Receive.RawData{1}); % UARP raw data
 
%% User defined parameters
%%%%%%%%%%%%%%%%%%%%% Tx %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ImagingDepth = UConfig.Procedure1.Operation1.Scan1.Receive.ImageDepth; % Imaging depth (m) to define RX duration
PRF = 1./UConfig.Procedure1.Operation1.Trigger.Period;               % in Hz
c = UConfig.Procedure1.Operation1.Scan1.SpeedOfSound;                  % Tissue = 1560 m/s, Phantom = 1520 m/s, Water = 1482 m/s 
APERTURE_Size = UConfig.Procedure1.Operation1.Scan1.LastElement-UConfig.Procedure1.Operation1.Scan1.FirstElement+1; % Size of aperature (# elements)
pitch = UConfig.Procedure1.Operation1.Transducers.ElementPitch;              % Element pitch for the L11-4 probe
Steering_Angles = UConfig.Procedure1.Operation1.Scan1.Transmit.SteeringAngle;

%% Beamforming parameters
downsampling = 1;           % Downsampling factor
fs = UConfig.Procedure1.Operation1.Scan1.Receive.SampleRate/downsampling;                  % Sampling frequency should be 80 MHz for UARP II
%% %%%%%%%%%%%%%%%%%%% Beamforming Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
first_minimum = 1;  % offset number
BeamformedLineStep = Steering_Angles(2)-Steering_Angles(1); % line angle step
MinRad = 0e-3;         % Beginning point   
MaxRad = ImagingDepth-10e-3; % End point
axial_step = c/fs/2; % Axial beamforming step in meter
%%
BeamformedAngleRange = max(Steering_Angles)-min(Steering_Angles);
activeElements      = UConfig.Procedure1.Operation1.Scan1.FirstElement:UConfig.Procedure1.Operation1.Scan1.LastElement;
N_elements          = length(activeElements);
imageLines          = BeamformedAngleRange./BeamformedLineStep+1;
%% !!!!!!!!!!Filtering parameters - Axial filtering in frequency domain (4-11 MHz)

Start_Passband_Freq = 3e6; %!!!!!!!!!!
Stop_Passband_Freq = 7e6; %!!!!!!!!!!   
Filter_Order = 94;

w1 = Start_Passband_Freq / (fs/2);
w2 = Stop_Passband_Freq / (fs/2);
Filter_Coeffs = fir1(Filter_Order, [w1 w2]);


% Check Frame #1

no_frame=1;

for imageLine = 1:1
    
% Active elements in line

  [Beamformed_DATA,Rad,Phi] = Phased_Offline_Beamformer_Polar_NegativeDelays(UARP_RAW_DATA(activeElements,first_minimum:end,imageLine)',imageLine,MinRad,MaxRad,...
    BeamformedLineStep, N_elements, pitch, c, fs,BeamformedAngleRange);
end

data_depth  = length(Beamformed_DATA(:,:,1));

Beamformed_DATA_Frame=zeros(data_depth,imageLines,no_frame);
Beamformed_DATA_filtered = zeros(data_depth,imageLines,no_frame);



%%

Thresh = -50;
frame_start =1;
frame_end = 1;

for frame = frame_start:frame_end 
   tic 
for imageLine = 1:imageLines 
    
% Active elements in line
  [Beamformed_DATA,Rad,Phi] = Phased_Offline_Beamformer_Polar_NegativeDelays(UARP_RAW_DATA(activeElements,first_minimum:end,imageLine)',imageLine,MinRad,MaxRad,...
    BeamformedLineStep, N_elements, pitch, c, fs,BeamformedAngleRange);

Beamformed_DATA_Frame(:,imageLine,frame) = Beamformed_DATA; 
end
toc

for k = 1:imageLines
        Temp = conv(Beamformed_DATA_Frame(:,k,frame), Filter_Coeffs);
        Beamformed_DATA_filtered(:,k,frame) = Temp(1+Filter_Order/2:end-Filter_Order/2);
end


Beamformed_DATA_dB = 20*log10(abs(hilbert(Beamformed_DATA_filtered(:,:,frame))));
Beamformed_DATA_dB= Beamformed_DATA_dB - max(max(Beamformed_DATA_dB));
%  
    figure(1),
    colormap(gray);
    polarPcolor_Luzhen(Rad*1e3,(Phi)',Beamformed_DATA_dB);
    
    caxis([Thresh 0]);
    view(180,90);
    ylabel('Depth [mm]','fontsize',15)
    xlabel('Lateral Distance [mm]','fontsize',15)
    set(gca,'xdir','reverse')
    drawnow
end

