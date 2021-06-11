% LF_Send_TX_Defaults.m
%
%   Version:    LUARP_1_1 (LUARP 1.1)
%   Type:       LUARP Fundamental (LF_)
%   Action:     Configure Cordic Transmitter Defaults
%
%   Usage:  
%       [Details] = UF_Send_TX_Defaults( Level, Start_Freq, Stop_Freq, Duration_Secs)
%       
%
%   Notes:
%        * * * Level * * *
%       Level = 2 (2 Level Pulsing) (Not Selected)
%       Level = 3 (3 Level Low Voltage Pulsing)
%       Level = 4 (5 Level Phase Inversion Pulsing) (Not Selected)
%       Level = 5 (5 Level Pulsing)
%       Level = 6 (3 Level Low Voltage Phase Inversion Pulsing)
%       Level = X (3 Level High Voltage Pulsing)
%
%        * * * Start Freq * * *
%       Start Freq in MHz
%
%        * * * Stop Freq * * *
%       Stop Freq in MHz
%
%        * * * Duration * * *
%       Duration in secs e.g. 1e-6 for 1 micro second.
%       This is different from UARP code.

%       This function incorporates sw_en which differs from UARP code...
%       ... e.g. (case 15) i.e. UF_TX_Enable


function [Details] = LF_Send_TX_Defaults( Level, Start_Freq, Stop_Freq, Duration_Secs)
    
    Duration = round(Duration_Secs * 1e9);

    window_factor = 0;
    RTZ_duration = Duration + 660;
    delay = 0;
    blanking = 0;

% % % Original UARP % % %    
%     five_hvp = 380;
%     five_dvp = 106;
%     five_dvn = 918;
%     five_hvn = 644;
%     three_hvp = 256;
%     three_hvn = 768;

% % % LUARP 100% % % %    
    five_hvp = 3;
    five_dvp = 2;
    five_dvn = 1022;
    five_hvn = 1021;
    three_hvp = 2;
    three_hvn = 1022;


    sw_en_bitmask = bin2dec('00000001');

    LF_Send_Command(1, 1, Start_Freq )
    LF_Send_Command(2, 1, Stop_Freq )
    LF_Send_Command(3, 1, window_factor )
    LF_Send_Command(4, 1, Duration )
    LF_Send_Command(5, 1, RTZ_duration );
    LF_Send_Command(6, 1, delay )
    LF_Send_Command(7, 1, blanking )
    LF_Send_Command(8, 1, Level )
    LF_Send_Command(9, 1, five_hvp )
    LF_Send_Command(10, 1, five_dvp )
    LF_Send_Command(11, 1, five_dvn )
    LF_Send_Command(12, 1, five_hvn )
    LF_Send_Command(13, 1, three_hvp )
    LF_Send_Command(14, 1, three_hvn )
    
    LF_Send_Command(0, 1, 0);    % Configure Cordic
    
    Details = struct(...
    'Start_Freq', Start_Freq,...
    'Stop_Freq', Stop_Freq,...
    'Duration', Duration_Secs,...
    'Levels', Level...
    );

    LF_Send_Command(15, 1, sw_en_bitmask)
    LF_Send_Command(0, 1, 0);    % Configure Cordic
    
end