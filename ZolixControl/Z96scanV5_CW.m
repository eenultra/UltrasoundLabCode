% scan for 96 well plate
% 9 mm spacing between wells, A-H and 1-12

% James McLaughlan
% 14th Oct 2014
% edited 11th Nov 2015 to include RT stage
% edited Aug 2016 to remove RT stage and include QC time/energy control
% edited Feb 2018 to use CW laser and IR sensor
% QCcontrol(1480, 50, 0, 0, 1,'N');

% X and Y stages only
% H1 is set to pos 0,0
% A1 is 63,0

%%
clearvars -except lc ZO QC AG IR

disp('Config...');

fName = '20180320_CWlaser_NP_PTT_B2';
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
sCOL = 6;%[1 3 5 7];%[1 2 3 4 5];%[2 3 4 5 6 7 8 9];  %+X axis - select which column you want to expose.

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



%% Init IR sensor
global IR 
IRportCOM  = 'COM21';    % COM port for IR sensor
tBuff      = 60;  % time buffer for before/after exposure data
timeConstant = 0.05; %loop 0.05s per iteration
sampleValue= (expTime/timeConstant) + (tBuff/timeConstant); 

allTempData = zeros(sampleValue,length(sROW),length(sCOL));
%%


input('Ready?');

for i=1:length(XlineN)      
    Xpos = XlineN(i);
    for j=1:length(YlineN)
        Ypos = YlineN(j);
        disp(['Moved to, ' num2str(8-(Ypos/9)) ', ' num2str((Xpos/9)+1)]); 
        Zmove('X',Xpos-xi,'R',0);pause(0.1);
        Zmove('Y',Ypos-yi,'R',0);pause(0.1);  
        pause(5);
%         %start IR sensor %%%%%        
            IR_OpenConnection_JM('COM21');
            pause(0.1)
            temperature_time = tic;
            temp=zeros(1,sampleValue);
            time=linspace(0,expTime+tBuff,sampleValue);
            iT=0;
            bytes=IR.Config.Serial.BytesAvailable;
            if(bytes)
                fread(IR.Config.Serial,bytes);
            end
                while(iT<=sampleValue)
                    %pause(0.1);
                    iT=iT+1;
                    time(iT)=toc(temperature_time);
                    %disp(num2str(time(iT)));
                        if (time(iT) >= 9.9) && (time(iT) <=10.1) %
                            disp('Laser on');
                            fprintf(QC,':INST:STAT 1');
                        elseif (time(iT) >= expTime+9.9 && (time(iT) <=expTime+10.1))%expTime ;
                            disp('Laser off');
                            fprintf(QC,':INST:STAT 0');   
                        end

                    IR_Temp_Burst_JM;
                    temp(iT)=IR_Temp_Average;

                    figure(999)    
                    plot(time(1:iT),temp(1:iT))
                    xlim([time(1) time(end)])
                    drawnow
               end

            IR_CloseConnection_JM(0);
            close(999);
            allTempData(1:length(temp),j,i) = temp;
%         %Stop IR sensor %%%%%
        
        [xi yi zi] = Zgetpos(1);
    end
end

%%
% Save data and close connections
save([fName '.mat'],'time','allTempData','sROW','sCOL');
fprintf(QC,':INST:STAT 0');pause(0.1);  

