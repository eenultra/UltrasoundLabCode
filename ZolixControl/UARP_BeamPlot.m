%% UARP acoustic field calibration using hydrophone and DAQ
% July 2014
% James McLaughlan

% Zolix position settings, set to max peak

clearvars -except lc ZO QC AG PWM

X0 = 40; % mm
Y0 = 55; % mm 
Z0 = 70; % mm

Xres = 0.25;
Yres = 0.10;
Zres = 0.20;

Xscan = X0;%(-5:Xres:5) + X0;
Yscan = (-5:Yres:5) + Y0;
Zscan = (-15:Zres:15) + Z0;

%%
%Initialise the DAQ Card
SPcardSt(200,500,20)
global cardInfo

%% Int UARP setting
%  Initialise variables

Volts    = 24;
Aperture = 80;

P   = zeros(cardInfo.setMemsize,length(Yscan),length(Zscan));
Pp  = zeros(length(Yscan),length(Zscan));
Pn  = zeros(length(Yscan),length(Zscan));

        Transducer      = US_Load_Transducer('L3_8');
        c               = 1482;                         % Velocity in medium (water at 24 degs
        Focal_Depth     = 30/1000;                      % Define Focal Depth
        Imaging_Depth   = 60e-3;                        % Depth to image in metres
        z_offset        = 10e-3;
        aperture_size   = Aperture;                     % Number of elements in an aperture
        no_apertures    = 1;                            % Number of apertures

        freq = 4E6;
        cyc  = 5;
        dur  = (cyc/freq)*1E9; % duration in ns

        Na    = 50; %number of averages per position
        Data  = zeros(cardInfo.setMemsize,Na);
        DELAY = 0;%178.8E-6;
        fprintf(QC,[':PULSE4:DELAY ' num2str(DELAY)]);

%% Run the UARP
    %XZ scan  
    input('Ready?');
    for k=1:length(Zscan)
        
    Zn = Zscan(k); % scan in Z
    Xn = Xscan;       % The non-moving axis
    
        for p=1:length(Yscan)

            Yn = Yscan(p); % scan in X
            ZOscan(Xn,Yn,Zn);pause(0.1);

            for i=1:Na
                [t,DAT]   = SPcardAq;
                Data(:,i) = DAT(:,1);
                %pause(0.095); %needed to be 10Hz for laser system
                %pause(0.01);
            end

            P(:,p,k) = HydrophoneInverseFilter(mean(Data,2),cardInfo.maxSamplerate,2);
            Pp(p,k)  = max(P(:,p,k));
            Pn(p,k)  = abs(min(P(:,p,k)));
            figure(1);plot(t,P(:,p,k)/1E6);xlim([0 40]);drawnow;
            figure(2);imagesc(Zscan,Yscan,Pn/1E6);colorbar;drawnow;

        end
    
    end
    
name = ['Pscan_UARP_F' num2str(freq/1E6) 'MHz_A' num2str(Aperture) '_' num2str(Volts) 'V_Fd' num2str(Focal_Depth*1E3) 'mm_R1_07Aug14_noP.mat'];

save(name,'Aperture','Volts','DELAY','t','freq','cyc','dur','c','Focal_Depth','Imaging_Depth','z_offset',...
 'Pp','Pn','Xscan','Yscan','Zscan','X0','Y0','Z0'); %'P',

SPcardEn;
    
             





