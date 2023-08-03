% scan for 96 well plate
% 9 mm spacing between wells, A-H and 1-12

% James McLaughlan
% 14th Oct 2014

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

time = 1; % exposure time in s

ROW = 1:8; % A,B,C,D,E,F,G,H
COL = 1:12;% 1-12

%C4,6,8
%D4,6,8
%E4,6,8
%F4,6,8

sROW = [8];  %+Y axis
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

agSetVolt(150E-3);

%%

input('Ready?');

for i=1:length(XlineN)
    Xpos = XlineN(i);
    for j=1:length(YlineN)
        Ypos = YlineN(j);
        disp(['Moved to, ' num2str(8-(Ypos/9)) ', ' num2str((Xpos/9)+1)]); 
        Zmove('X',Xpos-xi,'R',0);pause(0.1);
        Zmove('Y',Ypos-yi,'R',0);pause(0.1);  
        %input('Ready?');
        %COMMENT BACK IN WHEN READY FOR EXPERIMENTS!!
%         agon
%         disp('HIFU on');
%         pause(60);
%         disp('HIFU off');
%         agoff
        [xi yi zi] = Zgetpos(1);
    end
end


