out = instrfindall()


%% Open Serial Connection
%
% Function Prototype:
%   [status, statusEnum, fieldValue] = AFE5807.readFromRegister(deviceID,targetADC,targetField)
%
% Long Description:
%   This function will read a value for the specified field, ADC and
%   device. The value will be read from the copy of the registers stored in
%   the library rather than reading from the device itself.
%
% Globals Required:
%   CNC
%
% Globals Written:
%   CNC.Config.Serial
%   CNC.Config.Serial.Terminator
%   
% Parameters:
%   ComPortString : String of COM port e.g. 'COM3'
%
% Return Values:
%   status : The completion status of the function. true or false
%

function [status] = CNC_OpenConnection(ComPortString)

global CNC

if ~length(ComPortString)
    error('Function input requires variable ''ComPortString''. ')
end

try
    CNC.Config.Serial = serial(ComPortString);

    fopen(CNC.Config.Serial)
    CNC.Config.Serial.Terminator = char(26); %Set end of line terminator character to char(26)
    return false;
catch 0;
    return false;
end

%% Close Serial Connection

% Close Serial Port Object
fclose(CNC.Config.Serial);

% Delete Serial Port Object
delete(CNC.Config.Serial);

%% Configure 6K4 controller

%Set end of line terminator character to char(13)
fprintf(CNC.Config.Serial,':EOL13:')

%Set end of transmission terminator character to char(26)
fprintf(CNC.Config.Serial,':EOT26:')

%% Current Position

fprintf(CNC.Config.Serial,':!tpe:');

% Read response and drop terminators
str = fgetl(CNC.Config.Serial);

% Convert response to array
[C,matches] = strsplit(str,',','CollapseDelimiters',true);
for i=1:length(C)
    A(i) = str2num(cell2mat(C(i)));
end

CNC.CurrentPosition = A
%% Commanded Position & In position (Software Calculated)

fprintf(CNC.Config.Serial,':!tpc:');

% Read response and drop terminators
str = fgetl(CNC.Config.Serial);

% Convert response to array
[C,matches] = strsplit(str,',','CollapseDelimiters',true);
for i=1:length(C)
    A(i) = str2num(cell2mat(C(i)));
end

CNC.CommandedPosition = A;
CNC.InPosition = (CNC.CommandedPosition == CNC.CurrentPosition)

%% Full Status

% Flush buffer
while( CNC.Config.Serial.BytesAvailable )
    CNC.Config.Serial.BytesAvailable
    fgetl(CNC.Config.Serial);
end

% Send status command 
fprintf(CNC.Config.Serial,':!tas.1::!tas.5::!tas.13::!tas.14::!tas.15::!tas.16::!tas.17::!tas.18::!tino.6::!tss.1:');

while( CNC.Config.Serial.BytesAvailable ~= 44 )
    pause(0.01)
end

% Read response and drop terminators
str = fgetl(CNC.Config.Serial);
CNC.Moving(1) = 48~=str(1);
CNC.Moving(2) = 48~=str(2);
CNC.Moving(3) = 48~=str(3);
CNC.Moving(4) = 48~=str(4);

str = fgetl(CNC.Config.Serial);
CNC.Home(1) = 48~=str(1);
CNC.Home(2) = 48~=str(2);
CNC.Home(3) = 48~=str(3);
CNC.Home(4) = 48~=str(4);

str = fgetl(CNC.Config.Serial);
CNC.DriveShutdown(1) = 48~=str(1);
CNC.DriveShutdown(2) = 48~=str(2);
CNC.DriveShutdown(3) = 48~=str(3);
CNC.DriveShutdown(4) = 48~=str(4);

str = fgetl(CNC.Config.Serial);
CNC.DriveFault(1) = 48~=str(1);
CNC.DriveFault(2) = 48~=str(2);
CNC.DriveFault(3) = 48~=str(3);
CNC.DriveFault(4) = 48~=str(4);

str = fgetl(CNC.Config.Serial);
CNC.LimitHardPos(1) = 48~=str(1);
CNC.LimitHardPos(2) = 48~=str(2);
CNC.LimitHardPos(3) = 48~=str(3);
CNC.LimitHardPos(4) = 48~=str(4);
	
str = fgetl(CNC.Config.Serial);
CNC.LimitHardNeg(1) = 48~=str(1);
CNC.LimitHardNeg(2) = 48~=str(2);
CNC.LimitHardNeg(3) = 48~=str(3);
CNC.LimitHardNeg(4) = 48~=str(4);
	
str = fgetl(CNC.Config.Serial);
CNC.LimitSoftPos(1) = 48~=str(1);
CNC.LimitSoftPos(2) = 48~=str(2);
CNC.LimitSoftPos(3) = 48~=str(3);
CNC.LimitSoftPos(4) = 48~=str(4);

str = fgetl(CNC.Config.Serial);
CNC.LimitSoftNeg(1) = 48~=str(1);
CNC.LimitSoftNeg(2) = 48~=str(2);
CNC.LimitSoftNeg(3) = 48~=str(3);
CNC.LimitSoftNeg(4) = 48~=str(4);
	
str = fgetl(CNC.Config.Serial);
CNC.Enabled = 48~=str(1);

str = fgetl(CNC.Config.Serial);
CNC.Ready = 48~=str(1);

CNC

%% CNC Moving Status

% Flush buffer
while( s.BytesAvailable )
    s.BytesAvailable
    str = fgetl(s);
end

fprintf(s,':!tas.1:');
pause(0.001)

while( s.BytesAvailable ~= 5 )
    pause(0.001)
end

toc

% Read response and drop terminators
str = fgetl(s);
CNC.Moving(1) = 48~=str(1);
CNC.Moving(2) = 48~=str(2);
CNC.Moving(3) = 48~=str(3);
CNC.Moving(4) = 48~=str(4);
arab1015

toc

return any(CNC.Moving)

% 






