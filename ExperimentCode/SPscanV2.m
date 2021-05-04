%% 2D scan with Linear Probe

clearvars -except ZO QC AG

X0 = 51; % mm
Y0 = 51; % mm 
Z0 = 30; % mm

Xres = 1;
Yres = 0.5;
Zres = 0.5;

Xscan =  X0; % (-2:Xres:6) +
Yscan = (-5:Yres:5) + Y0;
Zscan = (-5:Zres:5) + Z0;

c  = 1480;  % m/s speed of sound
f0 = 63E-3; % focal length of 3.3MHz HIFU transducer
%fd = 49E-3; % focal length of the 7.5MHz detector
Na = 10;    % number of pulses per position

xScale = Yscan; % axis labels
yScale = Zscan; % axis labels

name = '20190501_NRPA_850nm_R6_Lon_Hoff';

%

%Initialise the DAQ Card
SPcardSt(500,500,22)
global cardInfo

%

data   = zeros(cardInfo.setMemsize,Na,length(Yscan),length(Zscan));
%Pmap   = zeros(length(Xscan),length(Yscan),length(Zscan))-50; % set for XY scan
Pmap   = zeros(length(Yscan),length(Zscan))-40; % set for XY scan
%Dat    = zeros(cardInfo.setMemsize,length(Xscan),length(Yscan),length(Zscan));
Dat    = zeros(cardInfo.setMemsize,length(Yscan),length(Zscan));

%%

input('Ready..?');
fprintf(QC,':INST:STAT 1');pause(0.1);
for i=1:length(Xscan)
    Xn = Xscan(i);
    
    for j=1:length(Yscan)
         Yn = Yscan(j);
         
        for k=1:length(Zscan)
            Zn = Zscan(k);

        ZOscan(Xn,Yn,Zn);
        pause(0.2);
        disp(['X ' num2str(Xn) 'mm, Y' num2str(Yn) 'mm, Z' num2str(Zn) 'mm']);
        
        agon;pause(0.1)
        for L = 1:Na
            [t,DAT]   = SPcardAq;
            data(:,L,j,k) = DAT(:,1);
        end
        agoff;pause(0.1)
        
        %Dat(:,i,j,k) = mean(data,2);
        Dat(:,j,k)   = mean(data(:,:,j,k),2);
        LC           = 20*log10(abs(hilbert(mean(data(:,:,j,k),2))));
        id1          = find(t >= 81.5 & t <= 81.6,1,'first');
        id2          = find(t >= 88.0 & t <= 88.1,1,'first');
        
        %Pmap(i,j,k) = max(LC(id1:id2));
        Pmap(j,k)   = max(LC(id1:id2));
        NORM        = max(max(max(Pmap)));
        
        figure(2);plot(t, LC,'b');xlim([0 90]);drawnow;%ylim([-20 0]);
        figure(3);imagesc(xScale,yScale,(Pmap)');colormap(gray);colorbar;drawnow;%,[-20 0]
        
        end
    
    disp('Saving Line...');
    save(['XPos_' num2str(Xn) 'mm_YPos_' num2str(Yn) 'mm_' name '_dat.mat'],'t','data','LC','Pmap','Na','Xscan','Yscan','Zscan','xScale','yScale','NORM','Dat');
    end

end

%Dat = squeeze(Dat);

SPcardEn;
fprintf(QC,':INST:STAT 0');pause(0.1);
%disp('Saving All...');
%save([name '_dat.mat'],'t','data','LC','Pmap','Na','Xscan','Yscan','Zscan','xScale','yScale','NORM','Dat');

%agoff