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

Xline = 0:26:99;  % 1-4 COL
Yline = 63:-26:0; % A-C ROW

time = 10; % exposure time in s

ROW = 1:3;% A,B,C
COL = 1:4;% 1-4

sROW = [1,1,1,1,2,2,2,2,3,3,3,3];  %+Y axis
sCOL = [1,2,3,4,1,2,3,4,1,2,3,4];  %+X axis

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

agSetVolt(250E-3);

Zlevel = 10;

%%

wellPosX = [0,-2,-2,2,2];
wellPosY = [0,-2,2,-2,2];
 
%  wellPosX = 0;
%  wellPosY = 0;

input('Ready?');

for i=1:length(XlineN)
        ZOscan(XlineN(i),YlineN(i),Zlevel)

        for k=1:length(wellPosX) % moving inside the well             
              ZOscan(XlineN(i)-wellPosX(k),YlineN(i)-wellPosY(k),Zlevel)              
              pause(1);
              agon
              disp('HIFU on');
              pause(time);
              disp('HIFU off');
              agoff                     
        end    
end


