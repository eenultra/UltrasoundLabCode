% THIS SCRIPT SETS UP AND OPENS COMS. FLUSHES BOTH BUFFERS WITH FOPEN
%Edited by James McLaughlan
%University of Leeds
%May 2017

global ST
ST = serial('COM2','BaudRate',19200,'DataBits',8);   % SETS SERIAL, PLEASE CHANGE TO COM REQUIRED
set(ST,'Terminator','CR');                           % SETS THE TERMINATION TYPE
ST.OutputEmptyFcn = @instrcallback;                  % SETS READ CALLBACK (NEEDED)
fopen(ST);                                           % OPENS COMS

fprintf(ST, 'ROBOFORTH');                                % SENDS ROBOFORTH
fprintf(ST, ' \n\r ');                                   % SENDS ADDITIONAL CR (NEEDED)
flushinput(ST) ;                                         % FLUSH INPUT BUFFER
flushoutput(ST);

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
   pause(2);
   disp('Calibrating, please wait');
   rtcmd = 'CALIBRATE';
   stCommand(rtcmd);pause(0.1); 
end

isCal   = input('Is arm calibrated? y/n ','s');
calTest = strcmp(isCal,'y');

rtcmd = 'CARTESIAN';
stCommand(rtcmd);pause(0.2);                               

POS = stWhere
        





