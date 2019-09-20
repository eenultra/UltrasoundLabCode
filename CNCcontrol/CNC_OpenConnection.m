%% Open Serial Connection
%
% Function Prototype:
%   [status] = CNC_OpenConnection(ComPortString)
%
% Long Description:
%   This function will open the specified COM port and configure the
%   terminator characters to char(26) as configured on the CNC system.
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
%   status : The completion status of the function. Returns: true or false
%

function [status] = CNC_OpenConnection(ComPortString)

global CNC

if ~length(ComPortString)
    error('Function input requires variable ''ComPortString''. ')
end

instruments = instrfind('Port',ComPortString);

for( inst=1:length(instruments) )
    if(  strcmp(instruments(inst).Status,'open') && strcmp(instruments(inst).Port,ComPortString)  )
        disp(['Closing instrument port number ' num2str(inst) ' (' ComPortString ').'])
        fclose(instruments(inst));
    end
end

try

    CNC.Config.Serial = serial(ComPortString);
    fopen(CNC.Config.Serial)
    CNC.Config.Serial.Terminator = char(26); %Set end of line terminator character to char(26)
    disp([ComPortString ' sucessfully opened.'])

    status =  true;
catch
    status = false;
    error(['Opening ' ComPortString ' failed.'])
    return
end

status = CNC_ConfigureController();
