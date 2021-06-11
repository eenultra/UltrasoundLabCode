% LF_OpenSerial.m
%
%   Version:    LUARP_1_1 (LUARP 1.1)
%   Type:       LUARP Fundamental (LF_)
%   Action:     Configure Serial Port
%
%   Usage:
%       Tries to first close the serial object if one exists.
%       Create global handle for serial port (s)
%       Set BaudRate, Termination, Flow Control and Byte Order
%       Open serial port object
%       COM_Port must be a string
%
%   Notes:
%       To be used at start of program.

try
    LF_CloseSerial;
catch 
end

global s;

s = serial('COM11');%COM1

s.BaudRate = 9600;
s.Terminator = 'CR/LF';
s.FlowControl = 'hardware';
s.ByteOrder = 'littleEndian';

fopen(s);