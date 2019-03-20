%Control thorlabs linear stages using APT protocol

%James McLaughlan
%University of Leeds
%Feb 2019

function pos = LS3move(mX,mY,mZ,sRange)

% all values are in mm
global xLS yLS zLS

timeout = 10;     % timeout for waiting the move to be completed
maxRange = sRange; % 25mm for linear stages, 50mm for compact stages

if sRange == 50
    pErr     = -2;     % error on move, +/- 0.01 (-1 sig fig) for linear, 0.001 (-2 sig fig) for compact 
else
    pErr     = -1;     % error on move, +/- 0.01 (-1 sig fig) for linear, 0.001 (-2 sig fig) for compact 
end

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
    if (roundn(xPos, pErr) == roundn(mX, pErr)) 
        break
    end
end

t2 = clock; % current time
while(etime(clock,t2)<timeout)   
    [ydrv,yPos]= yLS.GetPosition(0,0);     
    if (roundn(yPos, pErr) == roundn(mY, pErr))
        break
    end
end

t3 = clock; % current time
while(etime(clock,t3)<timeout)
     [zdrv,zPos]= zLS.GetPosition(0,0);    
    if (roundn(zPos, pErr) == roundn(mZ, pErr))
        break
    end
end

pos = [xPos,yPos,zPos]; %in mm

disp(['x = ' num2str(roundn(xPos, pErr)) 'mm, y = ' num2str(roundn(yPos, pErr)) 'mm, z = ' num2str(roundn(zPos, pErr)) 'mm']);

end