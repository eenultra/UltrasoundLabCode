% scan for 96 well plate
% 9 mm spacing between wells, A-H and 1-12

% James McLaughlan
% 14th Oct 2014

% X and Y stages only
% H1 is set to pos 0,0
% A1 is 63,0

%%
clearvars -except lc ZO QC AG RT EM

disp('Config...');

Xst = 0;
Yst = 0;

Xline = 0:9:99;  % 1-12 COL
Yline = 63:-9:0; % A-H ROW

ROW = 1:8; % A,B,C,D,E,F,G,H
COL = 1:12;% 1-12

sROW = [5];     %+Y axis
sCOL = [2];  %+X axis

time = 1;

if ((max(sROW > 8)) || (max(sCOL > 12)))
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

name = '20150709_R1_NR_SPR800_PA';

%%

input('Ready?');

for i=1:length(XlineN)
    Xpos = XlineN(i);
    for j=1:length(YlineN)
        Ypos = YlineN(j);
        disp(['Moved to, ' num2str(8-(Ypos/9)) ', ' num2str((Xpos/9)+1)]); 
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
