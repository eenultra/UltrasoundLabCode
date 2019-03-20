%Control thorlabs linear stages using APT protocol

%James McLaughlan
%University of Leeds
%Feb 2019

%NC - No position checking, as it caused problems. Will implement in scan
%code to ensure in correct place. 

function pos = LS3moveNC(mX,mY,mZ,maxRange)

% all values are in mm
global xLS yLS zLS

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

end