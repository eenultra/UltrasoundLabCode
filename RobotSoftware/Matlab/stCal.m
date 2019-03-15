%Runs the calibration command, and manually homes arm if needed.
%by James McLaughlan
%University of Leeds
%May 2017

function stCal

   isHomed = input('Is the arm homed? y/n ','s');
    if strcmp(isHomed,'n');
        rtcmd = 'DE-ENERGISE';
        stCommand(rtcmd)                               
        input('Manually move to home position, then press enter');
        rtcmd = 'ENERGISE';
        stCommand(rtcmd)
    end
   rtcmd = 'START';
   stCommand(rtcmd)
   pause(2);
   rtcmd = 'CALIBRATE';
   stCommand(rtcmd)
   disp('Calibrating, please wait');