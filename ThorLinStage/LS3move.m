%Control thorlabs linear stages using APT protocol

%James McLaughlan
%University of Leeds
%Feb 2019
%updated Mar 2019

 %pErr =  error on move, +/- 0.1 for linear, 0.01 for compact 
 
function pos = LS3move(mX,mY,mZ,sRange,pErr)
% all values are in mm
global xLS yLS zLS

timeout = 10;      % timeout for waiting the move to be completed
maxRange = sRange; % 25mm for linear stages, 50mm for compact stages

if (mX > maxRange) || (mY > maxRange) || (mZ > maxRange)
    disp('Movement out of range of stage');
    [xdrv,xPos]= xLS.GetPosition(0,0);pause(0.1);
    [ydrv,yPos]= yLS.GetPosition(0,0);pause(0.1);
    [zdrv,zPos]= zLS.GetPosition(0,0);pause(0.1);
    pos = [xPos,yPos,zPos];
    disp(['x = ' num2str(pos(1)) 'mm, y = ' num2str(pos(2)) 'mm, z = ' num2str(pos(3)) 'mm']);
    return  
end

xLS.SetAbsMovePos(0,mX);xLS.MoveAbsolute(0,0==1);
yLS.SetAbsMovePos(0,mY);yLS.MoveAbsolute(0,0==1);
zLS.SetAbsMovePos(0,mZ);zLS.MoveAbsolute(0,0==1);

t1 = clock; % current time
while(etime(clock,t1)<timeout)
    %redefine these each time so only when all three are 1 will loop stop
    xCheck = 0;yCheck = 0;zCheck = 0;  
    % check for x-axis
    [xdrv,NEWxPos]= xLS.GetPosition(0,0);pause(0.1);
    if (NEWxPos >= (mX - pErr)) && (NEWxPos <= (mX + pErr))
        xCheck = 1;
    end 
    %check for y-axis
    [ydrv,NEWyPos]= yLS.GetPosition(0,0);pause(0.1);
    if (NEWyPos >= (mY - pErr)) && (NEWyPos <= (mY + pErr))
        yCheck = 1;
    end 
    %check for z-axis
    [zdrv,NEWzPos]= zLS.GetPosition(0,0);pause(0.1);
    if (NEWzPos >= (mZ - pErr)) && (NEWzPos <= (mZ + pErr))
        zCheck = 1;
    end 
    %disp(['y position= ' num2str(NEWyPos) ' mm, aiming for between = ' num2str(mY-pErr) '-' num2str(mY+pErr) ' mm' ]);
    %disp(['xCheck = ' num2str(xCheck) ', yCheck = ' num2str(yCheck) ' zCheck = ' num2str(zCheck)]);
    
    if (xCheck == 1 && yCheck == 1 && zCheck == 1) 
        %disp('should be moving on');
        break
    end
    clear NEWxPos NEWyPos NEWzPos   
    xLS.MoveAbsolute(0,0==1);
    yLS.MoveAbsolute(0,0==1);
    zLS.MoveAbsolute(0,0==1);
end

pause(0.1);
[xdrv,xCPos]= xLS.GetPosition(0,0);
[ydrv,yCPos]= yLS.GetPosition(0,0);
[zdrv,zCPos]= zLS.GetPosition(0,0);

pos = [xCPos,yCPos,zCPos]; %in mm

%disp(['x = ' num2str(roundn(xPos, pErr)) 'mm, y = ' num2str(roundn(yPos, pErr)) 'mm, z = ' num2str(roundn(zPos, pErr)) 'mm']);
%disp(['x = ' num2str(xCPos) 'mm, y = ' num2str(yCPos) 'mm, z = ' num2str(zCPos) 'mm']);

end