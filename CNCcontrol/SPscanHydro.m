%% 2D scan with Linear Probe

clearvars -except lc ZO QC AG PWM RT

X0 = 60; % mm
Y0 = 50; % mm 
Z0 = 30; % mm

Xres = 1;
Yres = 0.5;
Zres = 0.5;

Xscan = (-15:Xres:15) + X0;
Yscan = Y0;
Zscan = (-5:Zres:5) + Z0;

c  = 1480;  % m/s speed of sound
f0 = 20E-3; % focal length of 2MHz transducer
Na = 100;    % number of pulses per position

xScale = Xscan; % axis labels
yScale = Zscan; % axis labels

name = 'hydroXZscan_2MHz_2Dscan_R1_05Jul16';

%%
%Initialise the DAQ Card
SPcardSt(200,500,8)
global cardInfo


Pmap   = zeros(length(Xscan),length(Zscan)); % set for XY scan
Dat    = zeros(cardInfo.setMemsize,length(Xscan),length(Zscan));

%%
%agoff
input('Ready..?');

for i=1:length(Xscan)
    Xn = Xscan(i);
    disp(['X=' num2str(Xn) 'mm, scan-line ' num2str(i) ' of ' num2str(length(Xscan))]);
    for j=1:length(Yscan)
         Yn = Yscan(j);
         
        for k=1:length(Zscan)
            Zn = Zscan(k);

        ZOscan(Xn,Yn,Zn);
        pause(0.2);
        data   = zeros(cardInfo.setMemsize,Na);
        %disp(['X ' num2str(Xn) 'mm, Y' num2str(Yn) 'mm, Z' num2str(Zn) 'mm']);
        
        agon;pause(0.1)
        for L = 1:Na
            [t,DAT]   = SPcardAq;
            data(:,L) = DAT(:,1)./335E-3;
        end
        agoff;pause(0.1)
        
        t1           = (f0-(Xscan(i) - X0)*1E-3)/c;
        t2           = t1 + 5E-6;
        Dat(:,i,k)   = mean(data,2);
        LC           = Dat(:,i,k);
        id1          = find(t >= t1 & t <= (t1 +0.1),1,'first');
        id2          = find(t >= t2 & t <= (t2 +0.1),1,'first');
        
        %Pmap(i,j,k) = max(LC(id1:id2));
        Pmap(i,k)   = max(Dat(id1:id2,i,k));%LC(id1:id2)

        figure(2);plot(t, LC,'b');xlim([0 35]);ylim([-0.2 0.2]); drawnow;
        figure(3);imagesc(xScale,yScale,(Pmap)');colormap(jet);colorbar;drawnow;
        
        end
    end
    disp('Saving Line...');
    save(['XPos_' num2str(Xn) 'mm_' name '_dat.mat'],'t','data','LC','Pmap','Na','Xscan','Yscan','Zscan','xScale','yScale');
end

%Dat = squeeze(Dat);

%%
SPcardEn;
disp('Saving All...');
save([name '_dat.mat'],'t','LC','Pmap','Na','Xscan','Yscan','Zscan','xScale','yScale');


%agoff