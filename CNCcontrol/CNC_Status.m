%% Full Status
%
% Function Prototype:
%   [status] = CNC_Status()
%
% Long Description:
%   This function will open the specified COM port and configure the
%   terminator characters to char(26) as configured on the CNC system.
%
% Globals Required:
%   CNC
%
% Globals Written:
%   None
%   
% Parameters:
%   None
%
% Return Values:
%   status : The completion status of the function. Returns: true or false
%

function [status] = CNC_Status()

global CNC

% Flush buffer
CNC_Flush();

% Send status command 
fprintf(CNC.Config.Serial,':!tas.1::!tas.5::!tas.13::!tas.14::!tas.15::!tas.16::!tas.17::!tas.18::!tino.6::!tss.1:');

while( CNC.Config.Serial.BytesAvailable ~= 44 )
    pause(0.01)
end

status = true;

% Axis 4 = X
% Axis 2 = Y
% Axis 1 = Z
% Axis 3 = R

axis_name = ['X','Y','Z','R'];

% Read response and drop terminators
str = fgetl(CNC.Config.Serial);
CNC.Moving(1) = 48~=str(4);
CNC.Moving(2) = 48~=str(2);
CNC.Moving(3) = 48~=str(1);
CNC.Moving(4) = 48~=str(3);

str = fgetl(CNC.Config.Serial);
CNC.Home(1) = 48~=str(4);
CNC.Home(2) = 48~=str(2);
CNC.Home(3) = 48~=str(1);
%CNC.Home(4) = 48~=str(3);




if( any(~CNC.Home) )
    for( i=1:3)
        if( ~CNC.Home(i) )
            disp(['WARNING: CNC ' axis_name(i) ' axis not homed. Absolute position not guaranteed.'])
        end
    end
end

str = fgetl(CNC.Config.Serial);
CNC.DriveShutdown(1) = 48~=str(4);
CNC.DriveShutdown(2) = 48~=str(2);
CNC.DriveShutdown(3) = 48~=str(1);
CNC.DriveShutdown(4) = 48~=str(3);

if( any(CNC.DriveShutdown) )
    for( i=1:length( CNC.DriveShutdown ))
        if( CNC.DriveShutdown(i) )
            disp(['ERROR: CNC drive shutdown on ' axis_name(i) ' axis.'])
            status = false;
        end
    end
end

str = fgetl(CNC.Config.Serial);
CNC.DriveFault(1) = 48~=str(4);
CNC.DriveFault(2) = 48~=str(2);
CNC.DriveFault(3) = 48~=str(1);
CNC.DriveFault(4) = 48~=str(3);

if( any(CNC.DriveFault) )
    for( i=1:length( CNC.DriveFault ))
        if( CNC.DriveFault(i) )
            disp(['ERROR: CNC drive in fault state on ' axis_name(i) ' axis.'])
            status = false;
        end
    end
end

str = fgetl(CNC.Config.Serial);
CNC.LimitHardPos(1) = 48~=str(4);
CNC.LimitHardPos(2) = 48~=str(2);
CNC.LimitHardPos(3) = 48~=str(1);
CNC.LimitHardPos(4) = 48~=str(3);
	
if( any(CNC.LimitHardPos) )
    for( i=1:length( CNC.LimitHardPos ))
        if( CNC.LimitHardPos(i) )
            disp(['ERROR: CNC drive hit hardware positive limit on ' axis_name(i) ' axis.'])
            status = false;
        end
    end
end

str = fgetl(CNC.Config.Serial);
CNC.LimitHardNeg(1) = 48~=str(4);
CNC.LimitHardNeg(2) = 48~=str(2);
CNC.LimitHardNeg(3) = 48~=str(1);
CNC.LimitHardNeg(4) = 48~=str(3);
	
if( any(CNC.LimitHardNeg) )
    for( i=1:length( CNC.LimitHardNeg ))
        if( CNC.LimitHardNeg(i) )
            disp(['ERROR: CNC drive hit hardware negative limit on ' axis_name(i) ' axis.'])
            status = false;
        end
    end
end

str = fgetl(CNC.Config.Serial);
CNC.LimitSoftPos(1) = 48~=str(4);
CNC.LimitSoftPos(2) = 48~=str(2);
CNC.LimitSoftPos(3) = 48~=str(1);
CNC.LimitSoftPos(4) = 48~=str(3);

if( any(CNC.LimitSoftPos) )
    for( i=1:length( CNC.LimitSoftPos ))
        if( CNC.LimitSoftPos(i) )
            disp(['ERROR: CNC drive hit software positive limit on ' axis_name(i) ' axis.'])
            status = false;
        end
    end
end

str = fgetl(CNC.Config.Serial);
CNC.LimitSoftNeg(1) = 48~=str(4);
CNC.LimitSoftNeg(2) = 48~=str(2);
CNC.LimitSoftNeg(3) = 48~=str(1);
CNC.LimitSoftNeg(4) = 48~=str(3);
	
if( any(CNC.LimitSoftNeg) )
    for( i=1:length( CNC.LimitSoftNeg ))
        if( CNC.LimitSoftNeg(i) )
            disp(['ERROR: CNC drive hit software negative limit on ' axis_name(i) ' axis.'])
            status = false;
        end
    end
end

str = fgetl(CNC.Config.Serial);
CNC.Enabled = 48~=str(1);

if( ~CNC.Enabled )
   disp(['ERROR: CNC driver not enabled.'])
   status = false;
end

str = fgetl(CNC.Config.Serial);
CNC.Ready = 48~=str(1);
if( ~CNC.Ready )
   disp(['ERROR: CNC driver not ready to receive commands.'])
   status = false;
end

