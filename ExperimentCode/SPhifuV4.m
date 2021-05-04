% Scan for quasi-CW HIFU exposures

% James McLaughlan
% Nov 2016


clearvars -except lc ZO QC AG RT EM
 %Set up 

nCyc = 330000;  % No of cycles, every 10Hz (laser rep rate)
f0   = 3.3E6;   % freq
dur  = 15;      % exposure time
PrPs = 1;       % pre and post acq time
dV   = 140;      % Agilent drive setting %95,130,165,200,230

%Initialise the DAQ Card
SPcardSt(2000,500,243)
global cardInfo
    
disp('Ready?');pause;

for j = 1:length(dV)
    
    name = ['20170529_P4_NR_839nm_Lon_40PC_' num2str(dV(j)) 'mV'];%[num2str(f0/1E6) 'MHz_Lon_850nm_NR_ND10_R1_' num2str(dV) 'mV_09Mar15'];

    %P1     
    %ZOscan(69,48,50);   
    %P2
    %ZOscan(69,48,57);
    %P3     
    %ZOscan(69,51,50);   
    %P4
    ZOscan(69,51,57);

    fs     = cardInfo.setSamplerate;
    Na     = round((dur + 2*PrPs)/0.1);
    data   = zeros(cardInfo.setMemsize,Na);

    agSetVolt(dV(j)*1E-3);pause(0.1);
    agSetBcnt(nCyc);pause(0.1);

    disp(['Drive: ' num2str(dV(j)) 'mV, Start!']);

    for i = 1:Na

        if ((PrPs/0.1) == i)
            %fprintf(QC,':PULSE4:STATE ON')
            agon
            disp('HIFU On!');
        end

        if (round(7.5/0.1) == i)
            disp('7.5s');
        end

        [t,DAT]   = SPcardAq;
        data(:,i) = DAT(:,1);

        if (((dur+PrPs)/0.1) == i)
            agoff
            %fprintf(QC,':PULSE4:STATE OFF')
            disp('HIFU Off');
        end

    end
    disp('Stop');
    agoff
    agSetBcnt(5);

    disp('Saving...');
    save([name '.mat'],'data','t','f0','fs','dur','PrPs','dV');

end

    SPcardEn;
    
    
%{
ZOscan(50,55,25);pause(1);agon;pause(10);agoff;pause(1);
ZOscan(53,55,25);pause(1);agon;pause(10);agoff;pause(1);
ZOscan(56,55,25);pause(1);agon;pause(10);agoff;pause(1);
ZOscan(58,55,25);pause(1);agon;pause(10);agoff;pause(1);
ZOscan(61,55,25);pause(1);agon;pause(10);agoff;pause(1);

ZOscan(50,55,28);pause(1);agon;pause(10);agoff;pause(1);
ZOscan(53,55,28);pause(1);agon;pause(10);agoff;pause(1);
ZOscan(56,55,28);pause(1);agon;pause(10);agoff;pause(1);
ZOscan(58,55,28);pause(1);agon;pause(10);agoff;pause(1);
ZOscan(61,55,28);pause(1);agon;pause(10);agoff;pause(1);

ZOscan(50,55,31);pause(1);agon;pause(10);agoff;pause(1);
ZOscan(53,55,31);pause(1);agon;pause(10);agoff;pause(1);
ZOscan(56,55,31);pause(1);agon;pause(10);agoff;pause(1);
ZOscan(58,55,31);pause(1);agon;pause(10);agoff;pause(1);
ZOscan(61,55,31);pause(1);agon;pause(10);agoff;pause(1);

ZOscan(50,55,34);pause(1);agon;pause(10);agoff;pause(1);
ZOscan(53,55,34);pause(1);agon;pause(10);agoff;pause(1);
ZOscan(56,55,34);pause(1);agon;pause(10);agoff;pause(1);
ZOscan(58,55,34);pause(1);agon;pause(10);agoff;pause(1);
ZOscan(61,55,34);pause(1);agon;pause(10);agoff;pause(1);

ZOscan(50,55,37);pause(1);agon;pause(10);agoff;pause(1);
ZOscan(53,55,37);pause(1);agon;pause(10);agoff;pause(1);
ZOscan(56,55,37);pause(1);agon;pause(10);agoff;pause(1);
ZOscan(58,55,37);pause(1);agon;pause(10);agoff;pause(1);
ZOscan(61,55,37);pause(1);agon;pause(10);agoff;pause(1);

ZOscan(50,55,40);pause(1);agon;pause(10);agoff;pause(1);
ZOscan(53,55,40);pause(1);agon;pause(10);agoff;pause(1);
ZOscan(56,55,40);pause(1);agon;pause(10);agoff;pause(1);
ZOscan(58,55,40);pause(1);agon;pause(10);agoff;pause(1);
ZOscan(61,55,40);pause(1);agon;pause(10);agoff;pause(1);

ZOscan(50,55,43);pause(1);agon;pause(10);agoff;pause(1);
ZOscan(53,55,43);pause(1);agon;pause(10);agoff;pause(1);
ZOscan(56,55,43);pause(1);agon;pause(10);agoff;pause(1);
ZOscan(58,55,43);pause(1);agon;pause(10);agoff;pause(1);
ZOscan(61,55,43);pause(1);agon;pause(10);agoff;pause(1);
%}

%%
%image test

%{

vidobj = videoinput('winvideo',1,'MJPG_1280x1024');%'YUY2_640x480'RGB24_1280x1024
% Configure the object for manual trigger mode.
triggerconfig(vidobj, 'manual');


start(vidobj)
dos('DN_DS_Ctrl.exe LED off -CAM0')
dos('DN_DS_Ctrl.exe AE off -CAM0')
figure(2)
for i=1:10

    frames = getsnapshot(vidobj);
    %frames = YUY2toRGB(getsnapshot(vidobj));
    imagesc(frames);drawnow
end


stop(vidobj);

%}

