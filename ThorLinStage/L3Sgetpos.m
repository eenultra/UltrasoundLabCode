%Get exact position of stages

%James McLaughlan
%University of Leeds
%Feb 2019

function pos = L3Sgetpos

global xLS yLS zLS; %

[xdrv,xPos]= xLS.GetPosition(0,0);
[ydrv,yPos]= yLS.GetPosition(0,0);
[zdrv,zPos]= zLS.GetPosition(0,0);

pos = [xPos,yPos,zPos]; %in mm

%disp(['x = ' num2str(pos(1)) 'mm, y = ' num2str(pos(2)) 'mm, z = ' num2str(pos(3)) 'mm']);