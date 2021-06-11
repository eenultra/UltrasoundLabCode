% LF_nShdn .m
%
%   Version:    LUARP_1_1 (LUARP 1.1)
%   Type:       LUARP Fundamental (LF_)
%   Action:     Disable Hardware Shutdown
%
%   Usage:
%       Configures input to MAX4811 Device
%
%   Notes:
%       Enables Devices

function LF_nShdn
    LF_Send_Command(99, 1, 1)
end