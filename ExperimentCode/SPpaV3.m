%% 2D scan with Linear Probe

clearvars -except lc ZO QC AG PWM RT

Na   = 50;                                  % number of pulses per position
dV   = [0 60:20:280];                       % drive setting on Agilent
Rrng = [10 20 30 40];%[80 70:-2:0];        % scan range, angle
Run  = [1 2 3];                             % number of repeats

%DELAY = 181.145E-6; 

X0 = 50; % mm
Y0 = 49; % mm 
Z0 = 50; % mm

Xres = 1;
Yres = 2;
Zres = 2; %90 to 44;

Xscan = X0;%(-15:Xres:15) + X0;
Yscan = [Y0-2 Y0 Y0+2];%(-30:Yres:30) + Y0;
Zscan = [32 36 40 44 48 52 56 60 64 68 72 76 82];%(-40:Zres:-12) + Z0;

if isequal(length(Zscan),length(dV)) == 0
    disp('Number of Pressure levels should equal gel locations!')
    break
end

if isequal(length(Yscan),length(Run)) == 0
    disp('Number of Repeats should equal gel locations!')
    break
end

%%
%Initialise the DAQ Card
SPcardSt(1000,500,23)
global cardInfo

data   = zeros(cardInfo.setMemsize,Na,length(Rrng),length(dV));

%%

%fprintf(QC,[':PULSE3:DELAY ' num2str(DELAY)]);

input('\nReady?');   
%fprintf(QC,':INST:STAT 1');pause(1);

for k = 1:length(Run)
    
    name = ['20170524_3p3MHz_Lon_PH_R' num2str(Run(k))];
    fprintf(QC,':INST:STAT 1');pause(1);
    data   = zeros(cardInfo.setMemsize,Na,length(Rrng),length(dV));
    
    for i=1:length(dV)

        pos = i*k;
        Xn  = Xscan;
        Yn  = Yscan(k);
        Zn  = Zscan(i);
        ZOscan(Xn,Yn,Zn);

        agSetVolt(dV(i)*1E-3);

        if dV(i) == 0
           agoff;pause(0.1);
        else
           agon;pause(0.1);
        end
        disp(['Drive Setting ' num2str(dV(i)) 'mV']);
        disp(['Z pos ' num2str(Zn) 'mm']);

        for j=1:length(Rrng)

            QCcontrol(1480, Rrng(j), 3.3E6, 63E-3, 6,'N');
            disp(['QS Power ' num2str(Rrng(j)) ' %']);

            if dV(i) == 0
            agoff;pause(0.1);
            else
            agon;pause(0.1);
            end

            for L = 1:Na
                [t,DAT]   = SPcardAq;
                data(:,L,j,i) = DAT(:,1);
            end

            id1 = find(t >= 80 & t <= 80.1,1,'first');
            id2 = find(t >= 90.0 & t <= 90.1,1,'first');       

            agoff;pause(0.1);
            figure(2);
            plot(data(id1:id2,Na,j,i));ylim([-0.5 0.5]);drawnow;
        end

    end

    %%
    
    fprintf(QC,':INST:STAT 0');pause(0.1);
    disp('Saving....');
    save([name '_dat.mat'],'t','data','id1','id2','dV','Rrng');

end

SPcardEn;