% LF_AWG_Clear .m
%
%   Version:    LUARP_1_1 (LUARP 1.1)
%   Type:       LUARP Fundamental (LF_)
%   Action:     Clear AWG Memory
%
%   Usage:
%       Use to clear preset memory
%
%   Notes:
%       None

function LF_AWG_Clear
    LF_Send_Command(30, 1, 0);
end