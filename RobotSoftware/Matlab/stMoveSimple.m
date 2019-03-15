%ST-Robotics simple

%James McLaughlan
%May 2017

global ST

%rc = 'TELL WAIST REVERSE 1000 MOVE';
rc = 'WHERE';
%rc = 'TELL SHOULDER REVERSE 1000 MOVE';
%rc = 'CARTESIAN';
fprintf(ST, '%s \n\r', rc);                              % SENDS COMMAND INPUTTED
fprintf(ST, ' \n\r ');                                   % SENDS ADDITIONAL CR (NEEDED)
flushinput(ST) ;                                         % FLUSH INPUT BUFFER
flushoutput(ST);                                         % FLUSH OUTPUT BUFFER
pause(1);
CONTROLLER = fscanf(ST, '%s') % READS CONTROLLER
pause(1)