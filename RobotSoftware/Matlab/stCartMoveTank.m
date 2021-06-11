%Cartesian move using X Y Z PITCH ROLL values
%input in mm with 0.1mm precision for X Y and Z,
%and in deg with 0.1 deg precision for PITCH and ROLL

%by James McLaughlan
%University of Leeds
%May 2017
% edit Jan 2020 for use in the tank, restricting X movement to not impact
% on sides.

function stCartMoveTank(newPOS)

global ST

xLimit = [-1100 1100];
yLimit = [1500 4500];
zLimit = [-3000 2500];

xMove = newPOS(1)*10; %covert into e.g. 1000 for 100mm
%need limit check code
if (xMove < xLimit(1)) || (xMove > xLimit(2)) 
    disp('x-axis movement out of range');
    error = 'x-axis movement out of range';
    return
end

yMove = newPOS(2)*10; %covert into e.g. 1000 for 100mm
%need limit check code
if (yMove < yLimit(1)) || (yMove > yLimit(2)) 
    disp('y-axis movement out of range');
    error = 'y-axis movement out of range';
    return
end

zMove = newPOS(3)*10; %covert into e.g. 1000 for 100mm
%need limit check code
if (zMove < zLimit(1)) || (zMove > zLimit(2)) 
    disp('z-axis movement out of range');
    error = 'z-axis movement out of range';
    return
end

pMove = newPOS(4)*10; %covert into e.g. 100 for 10.0deg
rMove = newPOS(5)*10; %covert into e.g. 100 for 10.0deg

rc = [num2str(rMove) ' ' num2str(pMove) ' ' num2str(zMove) ' ' num2str(yMove) ' ' num2str(xMove)  ' CM'];
fprintf(ST, '%s \n\r', rc);                              % SENDS COMMAND INPUTTED
fprintf(ST, ' \n\r ');                                   % SENDS ADDITIONAL CR (NEEDED)
flushinput(ST) ;                                         % FLUSH INPUT BUFFER
flushoutput(ST);
pause(0.1);
M1 = fscanf(ST, '%s');
M2 = fscanf(ST, '%s');
