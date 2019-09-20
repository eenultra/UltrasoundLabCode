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

function waveform = getWaveform(IP,ch)

scopeNotFound = 1;

maxAttempts = 100;

nAttempts = 1;

while(scopeNotFound == 1)
    disp(['Checking for Scope via ethernet ' IP ]);
    [scopeNotFound,~] = dos(['ping ' IP ' -n 1 -w 100']);
    nAttempts = nAttempts + 1;
    
    if(nAttempts == maxAttempts)
       return; 
    end
    pause(0.1);
end



disp(['Connecting to Agilent N6700B PSU via ethernet ' IP ]);
inst = connectSockets(IP,5025);

%javaclasspath(pwd) if not already

cmd = '*IDN?';
sendSockets(inst,cmd);

data = receiveLnSockets(inst,80);
disp(['Instrument Response: ' data( 1:(end-1) ) ])

%Take a measurement
%Stop the silly scope first
% cmd = 'STOP';
% sendSockets(inst,cmd);
% cmd = '*OPC?';
% sendSockets(inst,cmd);
% %Clear ADER event
% cmd = 'ADER?';
% sendSockets(inst,cmd);
% 
% %Send SINGle
% % cmd = 'SINGle';
% % sendSockets(inst,cmd);
% 
% %Wait until we have an acquisition:
% cmd = 'AER?';
% sendSockets(inst,cmd);
% data = receiveLnSockets(inst,80);
% data = str2num(data);

%pause(5);
%cmd = 'STOP';
%sendSockets(inst,cmd);

cmd = 'RUN';
sendSockets(inst,cmd);

%Wait while it's zero
% while( data == 0)
%     disp('Waiting...');
%     pause(0.1);
%     cmd = 'AER?';
%     sendSockets(inst,cmd);
%     data = receiveLnSockets(inst,80);
%     data = str2num(data);
% end

%pause(0.1);

%Work out length of data
%Set waveform source and type
cmd = [':WAVeform:SOURCe CHANNel' num2str(ch)];
sendSockets(inst,cmd);
cmd = ':WAVeform:FORMat ASCii';
sendSockets(inst,cmd);

%Find out how many points
cmd = ':WAVeform:POINts?';
sendSockets(inst,cmd);
data = receiveLnSockets(inst,80);
points = str2num(data);
disp(['Will gather ' num2str(points) ' pts']);

%Worst case size
maxLength = 11*points; %Format be like: -X.XXXE-XX,

%Get them datas
%Find out how many points
cmd = ':WAVeform:DATA?';
sendSockets(inst,cmd);
data = receiveLnSockets(inst,maxLength);

%Split by commas
data = strsplit(data,',');
%Convert to number array
S = sprintf('%s ', data{:});
waveform = sscanf(S, '%f');

cmd = 'RUN';
sendSockets(inst,cmd);

closeSockets(inst);
disp(['Disconnected from Agilent N6700B PSU via ethernet ' IP ]);

end
