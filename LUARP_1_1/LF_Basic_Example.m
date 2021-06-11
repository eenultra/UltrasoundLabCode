return

clc
clear all

%%
Serial_Port = 'COM1';
LF_OpenSerial

LF_Comms_Test
%%

Freq  = 1e6;
Dur = 3/Freq;

[Details] = LF_Send_TX_Defaults( 5, Freq, Freq, Dur);

LF_nShdn 

LF_Pulse

LF_Set_PRF(50)

LF_Pulse_PRF % enables on only
%%
LF_CloseSerial


%%
Time =2;
LF_Pulse_PRF % enables on only
pause(Time);
LF_Comms_Test