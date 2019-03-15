% scan for 24 well plate
% 9 mm spacing between wells, A-D and 1-6

% James McLaughlan
% 16th July 2015

% X and Y stages only
% H1 is set to pos 0,0
% A1 is 63,0

%%
clearvars -except lc ZO QC AG RT EM

disp('Config...');

Xst = 0;
Yst = 0;

Xline = 0:19.3:99;  % 1-6 COL
Yline = 63:-19.3:0; % A-D ROW

ROW = 1:4; % A,B,C,D
COL = 1:6;% 1-12

sROW = [1];     %+Y axis
sCOL = [2 3 4 5 6];  %+X axis

time = 1;

if ((max(sROW > 4)) || (max(sCOL > 6)))
    disp('Movement out of bounds, please choose again')
    break
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
load('RTvalues.mat');

Na = 100;   % number of pulses per position

%Initialise the DAQ Card
SPcardSt(500,500,5)
global cardInfo

dataTemp    = zeros(cardInfo.setMemsize,Na);
dataOut     = zeros(cardInfo.setMemsize,length(RTvals),length(wav));

name = '20150720_R1_NR_SPR800_PA';

%%

input('Ready?');

for i=1:length(XlineN)
    Xpos = XlineN(i);
    for j=1:length(YlineN)
        Ypos = YlineN(j);
        disp(['Moved to, ' num2str(Ypos) ', ' num2str(Xpos)]); 
        Zmove('X',Xpos-xi,'R',0);pause(0.1);
        Zmove('Y',Ypos-yi,'R',0);pause(0.1);  

        input(['Please Select Wavelength: ' num2str(wav(j)) 'nm']);       
        for k=1:length(RTvals)
            POS   = RTmove(RTvals(k,j));pause(0.1);
            disp(['Angle: ' num2str(roundn(POS,-1)) ' deg']);
            fprintf(QC,':INST:STAT 1');pause(0.1);
            for p=1:Na
               [t,DAT]       = SPcardAq;
               dataTemp(:,p) = DAT(:,1);
            end
            fprintf(QC,':INST:STAT 0');pause(0.1); 
            dataOut(:,k,i) = mean(dataTemp,2);
            
            id1 = find(t >= 10& t <= 10.1,1,'first');
            id2 = find(t >= 18.0 & t <= 18.1,1,'first'); 
            
            figure(2);plot(t(id1:id2),dataOut(id1:id2,k,i));drawnow
            
        end
           
        [xi yi zi] = Zgetpos(1);
        
    end
end



disp('Saving...');
save([name '_dat.mat'],'t','dataOut','id1','id2','RTvals','wav','Eval');


SPcardEn;
