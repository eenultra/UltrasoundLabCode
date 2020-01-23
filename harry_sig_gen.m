sg = ULab.SigGen.KEYSIGHT_3360xx('FunctionGenerator', 'TCP4', '192.168.42.106');

% Waveform config
sg.Function = 'sin';
sg.Frequency = 1.1e6;
sg.Amplitude = 1;
sg.Offset = 0;
sg.Phase = 0;

% Burst config
sg.Burst_Enabled = true;
sg.Burst_Cycles = 10;
sg.Burst_Mode = 'Triggered';

% Upload parameters
sg.configure;

% Enable output (configure disables output automatically)
sg.enable;