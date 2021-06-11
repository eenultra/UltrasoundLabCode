% LF_Shdn .m
%
%   Version:    LUARP_1_1 (LUARP 1.1)
%   Type:       LUARP Fundamental (LF_)
%   Action:     Enable Hardware Shutdown
%
%   Usage:
%       Configures input to MAX4811 Device
%
%   Notes:
%       None

function LF_Shdn
    LF_Send_Command(98, 1, 1)
end