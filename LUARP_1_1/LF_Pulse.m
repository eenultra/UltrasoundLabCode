% LF_Pulse.m
%
%   Version:    LUARP_1_1 (LUARP 1.1)
%   Type:       LUARP Fundamental (LF_)
%   Action:     Transmits (Pulses) the LUARP
%
%   Usage:
%       One call transmits once.
%
%   Notes:
%       Differs from Pulse PRF

function LF_Pulse
    LF_Send_Command(101, 1, 1)
end