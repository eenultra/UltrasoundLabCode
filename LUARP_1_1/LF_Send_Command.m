% LF_Send_Command.m
%
%   Version:    LUARP_1_1 (LUARP 1.1)
%   Type:       LUARP Fundamental (LF_)
%   Action:     Send Command / Data to LUARP
%
%   Usage:
%       Command = 0 to 255
%       Channel = 1 to 8 (Channel 0 is not valid in LUARP).
%       Board is always 1
%       Check is always 170 = 'AA' in hex
%   Notes:
%       Data is 32 bit which is split into 4 bytes...
%       ...using subfunction LS_ByteData (defined below)

function LF_Send_Command(Command, Channel, Data)
    
    global s;   % Global handle for serial port.

    if ((Channel < 1) || (Channel > 8))
       disp('Channels are numbered 1-8')
       return
    end

    Check = 170;    % Check Byte = 'AA' in hex
    Board = 1;      % Always talk to Board = 1

    % Channels are numbered 1-8 in LUARP...
    % ... this differs from UARP Channels (0-7)
    % Channel = 1 is most typical value.

    US_Command = [Check Board Command Channel]; % US_Command is generated
    US_Data = LS_ByteData(Data);  % 32 Bit data is split into 4 Bytes
%     Data
%     US_Data
    fwrite(s,US_Command);
    fwrite(s,US_Data);

end


function  [ByteData] = LS_ByteData(Data32)
    ByteData = [0 0 0 0];
    Hex32 = dec2hex(Data32,8);
    ByteData(1) = hex2dec(Hex32(1:2));
    ByteData(2) = hex2dec(Hex32(3:4));
    ByteData(3) = hex2dec(Hex32(5:6));
    ByteData(4) = hex2dec(Hex32(7:8));
end