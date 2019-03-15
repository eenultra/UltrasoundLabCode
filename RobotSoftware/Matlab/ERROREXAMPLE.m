% THIS EXAMPLE ASKS FOR AN INPUT, IF AN OK IS READ, IT WILL PRINT OK. IF AN
% ERROR IS RECIEVED, IT ASKS WETHER YOU WOULD LIKE TO SEE THE OUTPUT FOR
% THE ERROR WITH EITHER Y/N THEN ENDS

%Edited by James McLaughlan
%University of Leeds
%May 2017
global ST
%ROBINIT                                                 % OPENS COM
rc = input('ROBOT CONTROL:  ','s') ;                       % INPUT COMMAND TO SEND TO ROBOT 
fprintf(ST, '%s \n\r', rc);                              % SENDS COMMAND INPUTTED
fprintf(ST, ' \n\r ');                                   % SENDS ADDITIONAL CR (NEEDED)
flushinput(ST) ;                                         % FLUSH INPUT BUFFER
flushoutput(ST);                                         % FLUSH OUTPUT BUFFER
pause(1);
CONTROLLER = fscanf(ST, '%s');                           % READS CONTROLLER
pause(1);

if regexp(CONTROLLER, 'OK');                            % IF CONTROLLER READS 'OK'
    fprintf( 'OK\n' )                                   % PRINTS 'OK'
else fprintf( 'ERROR\n' )                               % OTHERWISE PRINTS 'ERROR'
    ui = input('SEE ERROR (Y/N): ','s');                    % ASKS TO SEE ERROR OR END
    if strcmp(ui,'Y');                                  % IF 'Y' ENTERED
            fgetl(ST)                                    % READ CONTROLLER
            pause(2)                                      
            fgetl(ST)                                    % READ AGAIN INCASE OF DELAY
    else strcmp(ui,'N');                                % IF 'N' ENTERED   
        return                                          % BREAK SCRIPT 
    end

end

%END                                                    % CLOSE COMS

