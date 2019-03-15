%Control thorlabs linear stages using APT protocol

%James McLaughlan
%University of Leeds
%Feb 2019

function pos = LS3move(mX,mY,mZ)

% all values are in mm
global xLS yLS zLS

timeout = 100; % timeout for waiting the move to be completed
maxRange = 25; %25mm for linear stages, 50mm for compact stages
pErr     = -1; % error on move, +/- 0.01 (-1 sig fig) for linear, 0.001 (-1 sig fig) for compact 

if (mX > maxRange) || (mY > maxRange) || (mZ > maxRange)
    disp('Movement out of range of stage');
    [xdrv,xPos]= xLS.GetPosition(0,0);
    [ydrv,yPos]= yLS.GetPosition(0,0);
    [zdrv,zPos]= zLS.GetPosition(0,0);
    pos = [xPos,yPos,zPos];
    disp(['x = ' num2str(pos(1)) 'mm, y = ' num2str(pos(2)) 'mm, z = ' num2str(pos(3)) 'mm']);
    return  
end

xLS.SetAbsMovePos(0,mX);xLS.MoveAbsolute(0,0==1);
yLS.SetAbsMovePos(0,mY);yLS.MoveAbsolute(0,0==1);
zLS.SetAbsMovePos(0,mZ);zLS.MoveAbsolute(0,0==1);

[xdrv,xPos]= xLS.GetPosition(0,0);
[ydrv,yPos]= yLS.GetPosition(0,0);
[zdrv,zPos]= zLS.GetPosition(0,0);

t1 = clock; % current time
while(etime(clock,t1)<timeout)
    [xdrv,xPos]= xLS.GetPosition(0,0);
    [ydrv,yPos]= yLS.GetPosition(0,0);
    [zdrv,zPos]= zLS.GetPosition(0,0);
    if (roundn(xPos, pErr) == roundn(mX, pErr)) && (roundn(yPos, pErr) == roundn(mY, pErr)) && (roundn(zPos, pErr) == roundn(mZ, pErr))
        break
    end
end

[xdrv,xPos]= xLS.GetPosition(0,0);
[ydrv,yPos]= yLS.GetPosition(0,0);
[zdrv,zPos]= zLS.GetPosition(0,0);

pos = [xPos,yPos,zPos]; %in mm

disp(['x = ' num2str(pos(1)) 'mm, y = ' num2str(pos(2)) 'mm, z = ' num2str(pos(3)) 'mm']);

end