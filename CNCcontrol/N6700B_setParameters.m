% Modified by Chris Adams for Agilent MSO-S 204A Scope
% Configure voltage and current setpoints on Agilent Technologies N6700B PSU.
%
% Function Prototype:
%   [status, statusEnum] = N6700B.setParameters(IP,voltage,current)
%
% Long Description:
%   This will disable outputs and then configure voltage and current
%   setpoints on a Agilent Technologies N6700B PSU via an ethernet
%   connection. The voltage and current array values are directly mapped to
%   channels 1 to 4 i.e. VPPB, VPPA, VNNA, VPPB respectivly. The following
%   must be true:
%           voltage(1) > voltage(2) > GND > voltage(3) > voltage(4)
%           VPPB       > VPPA       > GND > VNNA       > VNNB
%
%   If the function completes successfully, the number of channels will be
%   set in the global structure.
%
% Globals Required:
%   UARPLibEnums                  : Enumerated Types for PCIe Library
%   UARPConfig.Hardware.TX\
%                 .MaxPositiveVoltage : Maximum Voltage for +ve supply
%                 .MaxNegativeVoltage : Maximum Voltage for -ve supply
%
% Globals Written:
%   UARPConfig.Hardware.PSU \
%                 .VoltageSetPoint : Sets to updated value.
%   UARPConfig.Hardware.PSU \
%                 .CurrentSetPoint : Sets to updated value.
%   UARPConfig.Hardware.PSU \
%                 .ChannelEnabled  : Sets values to false.
% Parameters:
%   IP      : String containing the IP address of the N6700B PSU.
%   voltage : Array of voltage set point values.
%   current : Array of current set point values.
%
% Return Values:
%   status/statusEnum : The completion status of the function.
%

function [status, statusEnum] = N6700B.setParameters(IP,voltage,current)

global UARPConfig
UARPLibEnums  = UARP_Constants.empty.get('UARPLib.Enums');

% javaaddpath('.\_Hardware\Sockets','-end');
% temp_newpath = [pwd '\_GUI\images']; path(temp_newpath,path);
% UARP_Log.message('debug', ['Add MATLAB path: ' temp_newpath]);

% Validate input voltage parameters
if (( voltage(1) < 0 ) || ( voltage(1) > UARPConfig.Hardware.TX.MaxPositiveVoltage ))
    status = UARPLibEnums.UARPLIB_ERROR_CODES.UARPLIB_GENERAL_FAILURE;
    statusEnum = errorLookup(status);
    UARP_Log.message('Error', ['Voltage 1 must be in the range 0 <= V1 <= +' num2str(UARPConfig.Hardware.TX.MaxPositiveVoltage) '. Error Code: ' statusEnum]);
    return
end
if (( voltage(2) < 0 ) || ( voltage(2) > voltage(1)/2 ))
    status = UARPLibEnums.UARPLIB_ERROR_CODES.UARPLIB_GENERAL_FAILURE;
    statusEnum = errorLookup(status);
    UARP_Log.message('Error', ['Voltage 2 must be in the range 0 <= V2 <= V1/2 (+' num2str(voltage(1)/2) '). Error Code: ' statusEnum]);
    return
end
if (( voltage(4) > 0 ) || ( voltage(4) < -UARPConfig.Hardware.TX.MaxNegativeVoltage ))
    status = UARPLibEnums.UARPLIB_ERROR_CODES.UARPLIB_GENERAL_FAILURE;
    statusEnum = errorLookup(status);
    UARP_Log.message('Error', ['Voltage 4 must be in the range 0 >= V4 >= -' num2str(UARPConfig.Hardware.TX.MaxNegativeVoltage) '. Error Code: ' statusEnum]);
    return
end
if (( voltage(3) > 0 ) || ( voltage(3) < voltage(4)/2 ))
    status = UARPLibEnums.UARPLIB_ERROR_CODES.UARPLIB_GENERAL_FAILURE;
    statusEnum = errorLookup(status);
    UARP_Log.message('Error', ['Voltage 3 must be in the range 0 >= V3 >= V4/2 (-' num2str(abs(voltage(4)/2)) '). Error Code: ' statusEnum]);
    return
end

UARP_Log.message('Info', ['Checking for Agilent N6700B PSU via ethernet ' IP ]);
[psuNotFound,~] = dos(['ping ' IP ' -n 1 -w 100']);

if (psuNotFound)
    status = UARPLibEnums.UARPLIB_ERROR_CODES.UARPLIB_TIMED_OUT;
    statusEnum = errorLookup(status);
    UARP_Log.message('Error', ['Agilent N6700B PSU not found at IP ' IP '! Error Code: ' statusEnum]);
    return;
end

UARP_Log.message('Info', ['Connecting to Agilent N6700B PSU via ethernet ' IP ]);
inst = connectSockets(IP,5025);

cmd = '*IDN?';
sendSockets(inst,cmd);
UARP_Log.message('Debug', ['Command: ' cmd ]);

data = receiveLnSockets(inst,80);
UARP_Log.message('Info', ['Instrument Response: ' data( 1:(end-1) ) ]);

UARP_Log.message('Info', 'Disabling PSU outputs.');
% Turn outputs off
for channel = 1:4;
    channel_string = num2str(channel);
    cmd = ['OUTP OFF,(@' channel_string ')'];
    sendSockets(inst,cmd)
    UARP_Log.message('Debug', ['Command: ' cmd ]);

    UARPConfig.PSU.ChannelEnabled(channel) = false;
end

% Configure inhibit function on PSU
UARP_Log.message('Info', ['Enabling PSU output inhibit functionality.']);

cmd = 'DIG:PIN3:FUNC INH';
sendSockets(inst,cmd)
UARP_Log.message('Debug', ['Command: ' cmd ]);

cmd = 'DIG:PIN3:POL POS';
sendSockets(inst,cmd)
UARP_Log.message('Debug', ['Command: ' cmd ]);

cmd = 'OUTP:INH:MODE LIVE';
sendSockets(inst,cmd)
UARP_Log.message('Debug', ['Command: ' cmd ]);



UARP_Log.message('Info', ['Setting output voltage set points [ ' num2str(voltage) ' ].']);
UARP_Log.message('Info', ['Setting output current set points [ ' num2str(current) ' ].']);

% Set voltage and current for each channel
for channel = 1:4;
    voltage_string = num2str( abs(voltage(channel)) );
    curent_string = num2str( current(channel) );
    channel_string = num2str( channel );
    
    cmd = ['VOLT ' voltage_string ',(@' channel_string ')'];
    sendSockets(inst,cmd)
    UARP_Log.message('Debug', ['Command: ' cmd ]);
    UARPConfig.PSU.VoltageSetPoint(channel) = voltage(channel);
    
    cmd = ['CURR ' curent_string ',(@' channel_string ')'];
    sendSockets(inst,cmd)
    UARP_Log.message('Debug', ['Command: ' cmd ]);
    UARPConfig.PSU.CurrentSetPoint(channel) = current(channel);
end

closeSockets(inst);
UARP_Log.message('Info', ['Disconnected from Agilent N6700B PSU via ethernet ' IP ]);

status = UARPLibEnums.UARPLIB_ERROR_CODES.UARPLIB_SUCCESS;
statusEnum = errorLookup(status);

end
