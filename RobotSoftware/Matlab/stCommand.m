%A function to send a serial command to the R12 robot and read back the
%response.

%James McLaughlan
%University of Leeds
%May 2017

function stCommand(rc)

global ST

if isempty(ST)
    disp('Please make serial connection');
    return
end

fprintf(ST, '%s \n\r', rc);                              % SENDS COMMAND INPUTTED
fprintf(ST, ' \n\r ');                                   % SENDS ADDITIONAL CR (NEEDED)
flushinput(ST) ;                                         % FLUSH INPUT BUFFER
flushoutput(ST);                                         % FLUSH OUTPUT BUFFER
%pause(1);
%CONTROLLER = fscanf(ST,'%s'); % READS CONTROLLER
%pause(1)

%out = CONTROLLER;


