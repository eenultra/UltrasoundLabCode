% scan for 96 well plate
% 9 mm spacing between wells, A-H and 1-12

% James McLaughlan
% 14th Oct 2014
% edited 11th Nov 2015 to include RT stage
% edited Aug 2016 to remove RT stage and include QC time/energy control
% edited Fev 2018 to use CW laser and IR sensor
% QCcontrol(1480, 50, 0, 0, 1,'N');

% X and Y stages only
% H1 is set to pos 0,0
% A1 is 63,0

%%
clearvars -except lc ZO QC AG

disp('Config...');

Xst = 0;
Yst = 0;

Xline = 0:9:99;  % 1-12 COL
Yline = 63:-9:0; % A-H ROW

time = 50; % exposure time in s

ROW = 1:8; % A=1,B=2,C=3,D=4,E=5,F=6,G=7,H=8 - DO NOT CHANGE.
COL = 1:12;% 1-12 - DO NOT CHANGE.

%for d=5mm Z = 40mm.

%RTmove(10); % for d=5mm, F=26mJ/cm2 at 750nm %not needed for 1064nm beam

sROW = 4;%[1 2 3 4 5 6 7 8];  %+Y axis - select which rows you want to expose.
sCOL = 5;%[2 3 4 5 6 7 8 9];  %+X axis - select which column you want to expose.
sPC  = 100%[100 100 100 90 80 70 60 50]; 

if isequal(length(sPC),length(sCOL)) == 0
    disp('Number of Col does not equal no. of exposure levels');
    return
end

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

%%

input('Ready?');
fprintf(QC,':INST:STAT 1 ');pause(0.1);  
for i=1:length(XlineN)
    
    QCcontrol(1480, sPC(i), 0, 0, 0,'N');
    
    Xpos = XlineN(i);
    for j=1:length(YlineN)
        Ypos = YlineN(j);
        disp(['Moved to, ' num2str(8-(Ypos/9)) ', ' num2str((Xpos/9)+1) ', Energy Level:' num2str(sPC(i)) '%']); 
        Zmove('X',Xpos-xi,'R',0);pause(0.1);
        Zmove('Y',Ypos-yi,'R',0);pause(0.1);  
        %input('Ready?');
        %fprintf(QC,':INST:STAT 1');pause(0.1);
        pause(time);
        %fprintf(QC,':INST:STAT 0');pause(0.1);  
        [xi yi zi] = Zgetpos(1);
    end
end

fprintf(QC,':INST:STAT 0');pause(0.1);  

