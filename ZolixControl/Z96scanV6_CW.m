% scan for 96 well plate
% 9 mm spacing between wells, A-H and 1-12

% James McLaughlan
% 14th Oct 2014
% edited 11th Nov 2015 to include RT stage
% edited Aug 2016 to remove RT stage and include QC time/energy control
% edited Feb 2018 to use CW laser and IR sensor
% edited May 2018 to use CW laser and IR camera
% QCcontrol(1480, 50, 0, 0, 1,'N');

% X and Y stages only
% H1 is set to pos 0,0
% A1 is 63,0

%%
clearvars -except lc ZO QC AG IR

disp('Check Thermal Camera is Connected');
disp('Config...');

fName = '20181218CW_NP_PTT_C2';
%fName = '20180214_test';
nMin = 5; % number of mins for exposure time

Xst = 0;
Yst = 0;

Xline = 0:9:99;  % 1-12 COL
Yline = 63:-9:0; % A-H ROW

expTime = 60*nMin; % exposure time in s

ROW = 1:8; % A=1,B=2,C=3,D=4,E=5,F=6,G=7,H=8 - DO NOT CHANGE.
COL = 1:12;% 1-12 - DO NOT CHANGE.

sROW = [1 2 3 4 5 6 7 8];%[4 6 8];%[4 6 8];%[1 2 3 4 5 6 7 8];  %+Y axis - select which rows you want to expose.
sCOL = [6];%[1 3 5 7];%[1 2 3 4 5];%[2 3 4 5 6 7 8 9];  %+X axis - select which column you want to expose.

% if isequal(length(sPC),length(sCOL)) == 0
%     disp('Number of Col does not equal no. of exposure levels');
%     return
% end

if ((max(sROW > 8)) || (max(sCOL > 12)))
    disp('Movement out of bounds, please choose again')   
    return
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

%% Init IR camera
global IRInterface;
tBuff      = 30;  %s, time buffer for before/after exposure data
totalTime  = (tBuff*2 + expTime); % total temp aquisition time
rate       = 0.5;                 % aquire data every half second
totalSamples = totalTime/rate;    % number of temp frames

%%
input('Ready?');

figure(1);

for i=1:length(XlineN)      
    Xpos = XlineN(i);
    for j=1:length(YlineN)
        Ypos = YlineN(j);
        disp(['Moved to, ' num2str(8-(Ypos/9)) ', ' num2str((Xpos/9)+1)]); 
        Zmove('X',Xpos-xi,'R',0);pause(0.1);
        Zmove('Y',Ypos-yi,'R',0);pause(0.1);  
        pause(5); % pause after moving to position
        
        tData = zeros(480,640,totalSamples);
        
        for k = 1:totalSamples
        tic;
            if k == (tBuff/rate)
            disp('Laser on');
            fprintf(QC,':INST:STAT 1');
            end

            if k == (totalTime-tBuff)/rate
            disp('Laser off');
            fprintf(QC,':INST:STAT 0');
            end  

             % grab image data
               RGB = IRInterface.get_palette();                  % grab palette image
               THM = (IRInterface.get_thermal()-1000)/10;        % grab thermal image, convereted to deg C
               tData(:,:,k) = THM;
               imagesc(THM);colormap('hot');colorbar;drawnow;
               tt = toc;
               pause(rate-tt);
        end
        disp('Saving....');
        save([fName '_R' num2str(8-(Ypos/9)) '_C' num2str((Xpos/9)+1) '.mat'],'totalTime','rate','tBuff','tData','sROW','sCOL');
        [xi yi zi] = Zgetpos(1);
    end
end

%%
% Save data and close connections
%save([fName '.mat'],'time','allTempData','sROW','sCOL');
fprintf(QC,':INST:STAT 0');pause(0.1);  

