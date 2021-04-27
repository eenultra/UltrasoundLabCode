%fnopen;
%Opens up Agilent Function Generator
%Creates a global pointer called AG
%Not a true function as it has to pass the global variable

%James McLaughlan
%University of Leeds
%April 2021

global fgen

vAddress = 'USB0::2391::11015::MY58000535::0::INSTR';
fgen = visa('AGILENT',vAddress); %build IO object
fgen.Timeout = 15; %set IO time out
%calculate output buffer size
% buffer = length(arb)*8;
% set (fgen,'OutputBufferSize',(buffer+125));

%open connection to 33500A/B waveform generator
try
   fopen(fgen);
catch exception %problem occurred throw error message
    uiwait(msgbox('Error occurred trying to connect to the 33522, verify correct IP address','Error Message','error'));
    rethrow(exception);
end

%Query Idendity string and report
fprintf (fgen, '*IDN?');
idn = fscanf (fgen);
fprintf (idn)
fprintf ('\n\n')
