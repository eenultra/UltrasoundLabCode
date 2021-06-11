
clc
clear all

%% Setup
Serial_Port = 'COM1';
LF_OpenSerial

LF_Comms_Test

%%
Freq  = 1e6;
Dur = 3/Freq;
[Details] = LF_Send_TX_Defaults( 5, Freq, Freq, Dur);

LF_nShdn;

Command = 16;
Channel = 1;
Data = (bin2dec('11111111'));
LF_Send_Command(Command, Channel, Data); 

%%
Fs = 100E6;

F = 2.20e6;
B = 0.80*F;
Duration = 10e-6;

load PRE.mat

yi      = interp(Pre_win,100);
Pre_len = length(yi); 

pre_enhancement_window = decimate(yi,round(Pre_len/(Duration*Fs)));
pre_enhancement_window = pre_enhancement_window(1:1000)/max(pre_enhancement_window(1:1000));

[PWM s_t] = UARP_PWM(F, B, Duration, 4, 'User', pre_enhancement_window');
%[PWM s_t] = UARP_PWM(F, B, Duration, 4, 'None');

L = length(s_t);

LF_AWG_Clear;
LF_AWG_Load ( PWM );

LF_Set_PRF(50)

LF_Pulse_PRF % enables on only

%% For loop data

A  = 0.1:0.05:1;
F  = 1.5E6:0.1E6:3.5E6;
for j =1:length(F)
    
    Freq = F(j);
    
    for i = 1:length(A);

        Amplitude = A(i);
        Window    = (Amplitude)*ones(L,1);

        [PWM s_t] = UARP_PWM(Freq, B, Duration, 4, 'User', Window);

        LF_AWG_Clear;
        LF_AWG_Load ( PWM );
        LF_Pulse_PRF % enables on only
        name = ['LUARP_cal_02Aug12_A' num2str(Amplitude) '_F' num2str(Freq/1E6) 'MHz'];
        LUARP_cal(lc,name)

    end
    
end

%%

LF_Pulse

%%


%%
LF_CloseSerial


%%

Duration = 20e-6;

[PWM s_t] = UARP_PWM(F, B, Duration, 4, 'None');

L = length(s_t);


Window    = (linspace(0,L,L)/L)';
    
[PWM s_t] = UARP_PWM(F, B, Duration, 4, 'User', Window);

LF_AWG_Clear;
LF_AWG_Load ( PWM );