% LF_Pulse.m
%
%   Version:    LUARP_1_1 (LUARP 1.1)
%   Type:       LUARP Fundamental (LF_)
%   Action:     Transmits (Pulses) the LUARP
%
%   Usage:
%       Transmits until function is called again...
%
%   Notes:
%       Differs from LF_Pulse

function LF_Pulse_PRF
    
    LF_Send_Command(102, 1, 1)
    
%     if (STATUS)
%         msgbox('           L-UARP Pulsing','L-UARP','None');
%         disp('L-UARP Pulsing!')
%     elseif (~STATUS)
%         msgbox('           L-UARP Stopped','L-UARP','None');
%         disp('L-UARP Stopped!')
%     end
    disp('Pulse PRF')
end