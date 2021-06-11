% LF_Set_PRF .m
%
%   Version:    LUARP_1_1 (LUARP 1.1)
%   Type:       LUARP Fundamental (LF_)
%   Action:     Set the PRF value 
%
%   Usage:
%       LF_Set_PRF ( Frequency )
%       Frequency is the Pulse Repetition Frequency in Hz
%
%   Notes:
%       This is the frequency of the pulse trigger...
%       ...this function does not consider the waveform duration!

function LF_Set_PRF (Frequency)
    
    if ((Frequency > 100e3) || (Frequency < 31 ))
        disp('PRF Range is between 100 kHz and 32 Hz.')
%         disp('Pete needs to recompile this for 1 Hz')
    end
    
    Time = (1/Frequency);
    Cycles_1_MHz = round(Time/1e-6);
    
    LF_Send_Command(17, 1, Cycles_1_MHz )
    
end