% UARP acoustic field calibration using hydrophone and DAQ
% July 2014
% James McLaughlan

% Zolix position settings, set to max peak

clearvars -except lc ZO QC AG PWM

X0 = 50; % mm
Y0 = 30; % mm 
Z0 = 50; % mm

Xres = 0.25;
Yres = 1;
Zres = 0.5;

Xscan = X0;%(-5:Xres:5) + X0;
Yscan = Y0;%(-5:Yres:5) + Y0;
Zscan = Z0;%(2.5:Zres:10) + Z0;

%%
%Initialise the DAQ Card
SPcardSt(2000,500,16)
global cardInfo

%errorCode = spcm_dwSetParam_i64(cardInfo.hDrv, 100, 1); % card reset

%% Int UARP setting
%  Initialise variables

Volts    = 100;
Run      = 2;
Aperture = 8:2:52;%8:2:96;
Na       = 50; %number of averages per position

P   = zeros(cardInfo.setMemsize,length(Aperture),Run);
Pp  = zeros(length(Aperture),Run);
Pn  = zeros(length(Aperture),Run);
PpM = zeros(length(Aperture),1);
PnM = zeros(length(Aperture),1);
PpS = zeros(length(Aperture),1);
PnS = zeros(length(Aperture),1);

sData = zeros(cardInfo.setMemsize,Na,length(Aperture),Run);

%%
input('Start?');
for j=1:length(Aperture)
tic
        c               = 1480;                         % Velocity in medium (water at 24 degs
        Focal_Depth     = 40/1000;                      % Define Focal Depth
        aperture_size   = Aperture(j);%96;  % Number of elements in an aperture  
        freq            = 6E6;
        cyc             = 5;
        Data            = zeros(cardInfo.setMemsize,Na);
        DELAY           = 0;%178.8E-6;
        
        fprintf(QC,[':PULSE4:DELAY ' num2str(DELAY)]);       
        %dptr=UARP_TX(Focal_Depth*1E3,aperture_size,freq,cyc,Volts,DELAY);
        
        disp(['Change Aperture: ' num2str(aperture_size)]);%pause(0.5);
        
    % Run the UARP       
    for k =1:Run

        for i=1:Na
            [t,DAT]        = SPcardAq; % need to trig the UARP insided the DAQ loop  UF_Pulse_Read_Data(dptr, DEPTH, 97, 1);
            Data(:,i)      = DAT(:,1);
            sData(:,i,j,k) = Data(:,i);
        end

        P(:,j,k) = mean(Data,2)/0.21;%V/MPa %HydrophoneInverseFilter(mean(Data,2),cardInfo.maxSamplerate,2);
        Pp(j,k)  = max(P(:,j,k));
        Pn(j,k)  = abs(min(P(:,j,k)));
        figure(1);plot(t-1.8,P(:,j,k));xlim([0 35]);drawnow

    end
    
    PpM = mean(Pp,2);
    PpS = std(Pp,[],2);   
    PnM = mean(Pn,2);
    PnS = std(Pn,[],2);
    
    figure(2);errorbar(Aperture,PnM,PnS,'.','LineWidth',2);drawnow
   toc 
end

name = ['Pcal_UARP_F' num2str(freq/1E6) 'MHz_A' num2str(Aperture(1)) '-' num2str(Aperture(end)) '_R' num2str(Run) '_Fd' num2str(Focal_Depth*1E3) 'mm_17Sept14.mat'];

save(name,'Aperture','Volts','DELAY','t','Run','freq','cyc','c','Focal_Depth',...
    'P','Pp','Pn','PpM','PpS','PnM','PnS','sData');

SPcardEn;




%{
SPcardSt(200,200,22)
global cardInfo


Na   = 100;
Data = zeros(cardInfo.setMemsize,Na);

for i=1:Na
    [t,DAT]   = SPcardAq;
    Data(:,i) = DAT(:,1);
end

P = HydrophoneInverseFilter(mean(Data,2),cardInfo.maxSamplerate,2);

plot((t*c)/1E3,P/1E6);


SPcardEn
%}
             





