% THIS SCRIPT CLOSES THE COM AND CLEARS THE WORKSPACE. FLUSHES BOTH BUFFERS
% WITH FCLOSE
%Edited by James McLaughlan
%University of Leeds
%May 2017

global ST
stCommand('DE-ENERGISE');
pause(0.5);
fclose(ST);     % CLOSE COM
delete(ST);       % CLEARS WORKSPACE OF SERIAL CONNECTION. TEMPORARY. USE DELETE TO REMOVE ENTIRELY
clear all;