% scan for 96 well plate
% 9 mm spacing between wells, A-H and 1-12
% moves HIFU transducer and records with PCD

% James McLaughlan
% 7th August 2023

% X and Y stages only
% H1 is set to pos 0,0
% A1 is 63,0

%% Configure experimental equiptment for exposures and movement
clearvars -except lc ZO QC AG

disp('Config...');

Xst = 0;
Yst = 0;

Xline = 0:9:99;  % 1-12 COL
Yline = 63:-9:0; % A-H ROW

time      = 1;     % exposure time in s
usPRF     = 1E3;   % set HIFU PRF
HIFUfreq  = 1.1E6; % set HIFU freq
Na        = 100;   % number of cycles per burst 

time_Na   = Na/HIFUfreq;  % time for a single burst given Na and HIFU freq chosen
tot_Na    = 5;%time*usPRF;   % total number of pulses per position

agSetFreq(HIFUfreq)
agSetVolt(150E-3);
agSetBcnt(Na);

ROW = 1:8; % A,B,C,D,E,F,G,H
COL = 1:12;% 1-12

sROW = [1 8];  %+Y axis
sCOL = [12];  %+X axis

if ((max(sROW > 8)) || (max(sCOL > 12)))
    disp('Movement out of bounds, please choose again')
end

for jj = 1:length(sROW)
    idR(jj) = find(ROW == sROW(jj));
end

for ii = 1:length(sCOL)
    idC(ii) = find(COL == sCOL(ii));
end

XlineN = Xline(idC);
YlineN = Yline(idR);

[xi yi zi] = Zgetpos(0);

%%

cardFs = 125;                        %MHz, DAQ card sample freq
noCh   = 1;                          %DAQ card number of active chanels ch0,ch1
dtime  = 1024/(cardFs*1E6);          %time for one aqLen give current card sample freq
aqLen  = round(time_Na/dtime)+2;     %DAQ card number of sample blocks per trig event

%Initialise the DAQ Card
daqStSingleAq(aqLen,noCh,cardFs,[200 200],[1 1],1)
global cardInfo

%%

fName = 'test';

input('Ready?');

for i=1:length(XlineN)
    Xpos = XlineN(i);
    for j=1:length(YlineN)
        dataOut = zeros(cardInfo.setMemsize,tot_Na);
   
        Ypos = YlineN(j);
        disp(['Moved to, ' num2str(8-(Ypos/9)) ', ' num2str((Xpos/9)+1)]); 
        Zmove('X',Xpos-xi,'R',0);pause(0.1);
        Zmove('Y',Ypos-yi,'R',0);pause(0.1);  
       
        fprintf(QC,':INST:STAT 1');pause(0.1);
        for p=1:tot_Na
           [t,DAT]       = daqSAqu;
           dataOut(:,p)  = DAT;
        end
        fprintf(QC,':INST:STAT 0');pause(0.1); 

              %id1 = find(t >= 10& t <= 10.1,1,'first');
              %id2 = find(t >= 18.0 & t <= 18.1,1,'first'); 
              %figure(2);plot(t(id1:id2),dataOut(id1:id2,k,i));drawnow
              
        [xi,yi,zi] = Zgetpos(1);       
        disp('saving data');
        save([fName '_COL' num2str(sCOL(i)) '_ROW' num2str(sROW(j)) '.mat'],'dataOut','usPRF','HIFUfreq','sROW','sCOL');
    end
end

%%

daqEnSingleAq

