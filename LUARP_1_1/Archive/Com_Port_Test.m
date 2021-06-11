%% Com Port Test
clc
s = serial('COM1');

s.BaudRate = 9600;
s.Terminator = 'CR/LF';
s.FlowControl = 'hardware';
s.ByteOrder = 'littleEndian';
s.PinStatus

fopen(s);
%%
check = 170;
board = 1;
command = 7;
channel = 1;

Data32 = hex2dec('BBAAAAAA')

US_Command = [check board command channel];

US_Data = US_ByteData(Data32)

fwrite(s,US_Command);

fwrite(s,US_Data);

%%
fclose(s)
delete(s)
clear all