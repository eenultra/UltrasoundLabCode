% THIS EXAMPLE DEMONSTRATES THE CONTINUATION OF FUNCTIONS TO ROBOT IF 'OK'
% IS READ
global ST
%ROBINIT                                                 % OPENS COM
fprintf(ST, 'ROBOFORTH');                                % SENDS ROBOFORTH
fprintf(ST, ' \n\r ');                                   % SENDS ADDITIONAL CR (NEEDED)
flushinput(ST) ;                                         % FLUSH INPUT BUFFER
flushoutput(ST);                                         % FLUSH OUTPUT BUFFER
pause(1);
CONTROLLER = fscanf(ST, '%s');                           % READS CONTROLLER
pause(1);
if regexp(CONTROLLER, 'OK');                            % IF CONTROLLER READS 'OK'
    fprintf( 'STARTING\n' )                             % FOR DEBUGGING- REMOVE
    fprintf(s, 'START');                                % SENDS START
    fprintf(s, ' \n\r ');                               % SENDS ADDITIONAL CR (NEEDED)
    flushinput(ST) ;                                     % FLUSH INPUT BUFFER
    flushoutput(ST);                                     % FLUSH OUTPUT BUFFER
    pause(1);
    CONTROLLER;                                         % READS CONTROLLER
    pause(1);
        if regexp(CONTROLLER, 'OK');                    % IF CONTROLLER READS 'OK'
        fprintf( 'CALIBRATING\n' )                      % FOR DEBUGGING- REMOVE
        fprintf(ST, 'CALIBRATE HOME');                   % SENDS CALIBRATE
        fprintf(ST, ' \n\r ');                           % SENDS ADDITIONAL CR (NEEDED)
        flushinput(ST) ;                                 % FLUSH INPUT BUFFER
        flushoutput(ST);                                 % FLUSH OUTPUT BUFFER
        pause(1);
        CONTROLLER;                                      % READS CONTROLLER
        pause(1);
                if regexp(CONTROLLER, 'OK');             % IF CONTROLLER READS 'OK'
                fprintf( 'ALL CHECKED AND WORKING\n' )   % FOR DEBUGGING- REMOVE
                end
        end
else fprintf( 'ERROR\n' )                                % FOR DEBUGGING- REMOVE
end
        
%END                                                      % CLOSES COM
