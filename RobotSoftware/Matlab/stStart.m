% THIS SCRIPT SETS UP AND OPENS COMS. FLUSHES BOTH BUFFERS WITH FOPEN
%Edited by James McLaughlan
%University of Leeds
%May 2017

global ST
ST = serial('COM4','BaudRate',19200,'DataBits',8);   % SETS SERIAL, PLEASE CHANGE TO COM REQUIRED
set(ST,'Terminator','CR');                           % SETS THE TERMINATION TYPE
ST.OutputEmptyFcn = @instrcallback;                  % SETS READ CALLBACK (NEEDED)
fopen(ST);                                           % OPENS COMS

rtcmd = 'START';
stCommand(rtcmd)

stCal = input('Do you want calibrate? y/n ','s');
if strcmp(stCal,'y');
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
end

%isCart = input('Do you want Cartesian (i.e. Rev Kin)? y/n ','s');
%if strcmp(isCart,'y');
   rtcmd = 'CARTESIAN';
   stCommand(rtcmd)                               
%end


        





