%% Clear
clear all
clc

%% LUARP OpenSerial

LF_OpenSerial

%% LUARP CloseSerial

LF_CloseSerial

%% LUARP LF_Shdn

LF_Shdn % Command 98 (Disable Devices)

%% LUARP LF_nShdn

LF_nShdn % Command 99 (Enable Devices)

%% LUARP LF_Pulse

LF_Pulse % Command 101

%% LUARP LF_Pulse_PRF

LF_Pulse_PRF % Command 102

%% LUARP LF_Set_PRF

LF_Set_PRF (50) 

%% LUARP Pulse_mSec

Command = 103;
Channel = 1;

mSec = 100;
Data = mSec * 1e3;
 
LF_Send_Command(Command, Channel, Data)

%% LUARP LF_Send_TX_Defaults
% [Details] = LF_Send_TX_Defaults( Level, Start_Freq, Stop_Freq, Duration_Secs)

[Details] = LF_Send_TX_Defaults( 5, 1e6, 1e6, 2e-6);

%% LUARP AWG Clear (Case 30)

Command = 30;
Channel = 1;
Data = 0;   % Data is not used...
 
LF_Send_Command(Command, Channel, Data)

%% LUARP AWG Load (Case 31)

[PWM s_t] = UARP_PWM(2e6, 0e6, 20e-6, 5, 'User', 0.45*ones(2000,1));

LF_AWG_Load ( PWM )

%% LUARP Preset Select (Case 32)

Command = 32;
Channel = 1;
Data = 1;   % Data is 1 - 8!
 
LF_Send_Command(Command, Channel, Data)

%% LUARP Configure All (Case 0)

Command = 0;
Channel = 1;
Data = 0;   % Data is not used...
 
LF_Send_Command(Command, Channel, Data)

%% LUARP Start Frequency (Case 1)

Command = 1;
Channel = 1;
Data = 1e6;   % Frequency in Hz!

LF_Send_Command(Command, Channel, Data)

%% LUARP Stop Frequency (Case 2)

Command = 2;
Channel = 1;
Data = 2e6;   % Frequency in Hz!

LF_Send_Command(Command, Channel, Data)

%% LUARP Window Factor (Case 3)

Command = 3;
Channel = 1;
Data = 100;   % Tukey Window Percentage

LF_Send_Command(Command, Channel, Data)

%% LUARP Duration (Case 4)

Command = 4;
Channel = 1;
Data = 1000;   % Signal Duration in ns

LF_Send_Command(Command, Channel, Data)

%% LUARP RTZ Duration (Case 5)

Command = 5;
Channel = 1;
Data = 1660;   % Needs to be Duration + 660.

LF_Send_Command(Command, Channel, Data)

%% LUARP Delay (Case 6)

Command = 6;
Channel = 1;
Data = 0;   % Delay in integers of 10ns

LF_Send_Command(Command, Channel, Data)

%% LUARP Blanking (Case 7)

Command = 7;
Channel = 1;
Data = 0;   % Blanking Period

LF_Send_Command(Command, Channel, Data)

%% LUARP LevelSel (Case 8)

Command = 8;
Channel = 1;
Data = 5;
% Level = 2 (2 Level Pulsing) (Not Selected)
% Level = 3 (3 Level Low Voltage Pulsing)
% Level = 4 (5 Level Phase Inversion Pulsing) (Not Selected)
% Level = 5 (5 Level Pulsing)
% Level = 6 (3 Level Low Voltage Phase Inversion Pulsing)
% Level = X (3 Level High Voltage Pulsing)

LF_Send_Command(Command, Channel, Data)

%% LUARP hvp (Case 9)

Command = 9;
Channel = 1;
Data = 3;   % hvp level signed binary

LF_Send_Command(Command, Channel, Data)

%% LUARP dvp (Case 10)

Command = 10;
Channel = 1;
Data = 2;   % dvp level signed binary

LF_Send_Command(Command, Channel, Data)

%% LUARP dvn (Case 11)

Command = 11;
Channel = 1;
Data = 1022;   % dvn level signed binary

LF_Send_Command(Command, Channel, Data)


%% LUARP hvn (Case 12)

Command = 12;
Channel = 1;
Data = 1021;   % hvn level signed binary

LF_Send_Command(Command, Channel, Data)

%% LUARP 3 hvp (Case 13)

Command = 13;
Channel = 1;
Data = 2;   % three hvp level signed binary

LF_Send_Command(Command, Channel, Data)


%% LUARP 3 hvn (Case 14)

Command = 14;
Channel = 1;
Data = 1022;   % three hvn level signed binary

LF_Send_Command(Command, Channel, Data)

%% LUARP Sw_En (Case 15) ? Necessary ?

Command = 15;
Channel = 1;
Data = (bin2dec('00000001'));   % sw_en ('11111111') bit per channel?

LF_Send_Command(Command, Channel, Data)

%% LUARP Output Select (Case 16)

Command = 16;
Channel = 1;
Data = (bin2dec('11111111'));
% Bitmask = '00000000' is Cordic
% Bitmask = '11111111' is AWG

LF_Send_Command(Command, Channel, Data)

%% Preset Design Params

% Preset 1
f = 1e6; B = 0; T = 5/f; window = 'Hann';
[PWM_p1 s_t_p1] = UARP_PWM(f, B, T, 5, window);
[MIF1] = UARP_MIF_PWM(PWM_p1);

% Preset 2
f = 1e6; B = 0; T = 10/f; window = 'Hann';
[PWM_p2 s_t_p2] = UARP_PWM(f, B, T, 5, window);
[MIF2] = UARP_MIF_PWM(PWM_p2);

% Preset 3
f = 1e6; B = 0; T = 15/f; window = 'Hann';
[PWM_p3 s_t_p3] = UARP_PWM(f, B, T, 5, window);
[MIF3] = UARP_MIF_PWM(PWM_p3);

% Preset 4
f = 1e6; B = 0; T = 20/f; window = 'Hann';
[PWM_p4 s_t_p4] = UARP_PWM(f, B, T, 5, window);
[MIF4] = UARP_MIF_PWM(PWM_p4);

% Preset 5
f = 2e6; B = 0; T = 10/f; window = 'Hann';
[PWM_p5 s_t_p5] = UARP_PWM(f, B, T, 5, window);
[MIF5] = UARP_MIF_PWM(PWM_p5);

% Preset 6
f = 2e6; B = 0; T = 20/f; window = 'Hann';
[PWM_p6 s_t_p6] = UARP_PWM(f, B, T, 5, window);
[MIF6] = UARP_MIF_PWM(PWM_p6);

% Preset 7
f = 2e6; B = 0; T = 30/f; window = 'Hann';
[PWM_p7 s_t_p7] = UARP_PWM(f, B, T, 5, window);
[MIF7] = UARP_MIF_PWM(PWM_p7);

% Preset 8
f = 2e6; B = 0; T = 40/f; window = 'Hann';
[PWM_p8 s_t_p8] = UARP_PWM(f, B, T, 5, window);
[MIF8] = UARP_MIF_PWM(PWM_p8);