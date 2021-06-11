% LF_CloseSerial.m
%
%   Version:    LUARP_1_1 (LUARP 1.1)
%   Type:       LUARP Fundamental (LF_)
%   Action:     Close Serial Port
%
%   Usage:
%       Closes the serial port created by LF_OpenSerial
%
%   Notes:
%       To be used at end of program.

% fclose(s)
% delete(s)
delete(instrfindall);
clear s