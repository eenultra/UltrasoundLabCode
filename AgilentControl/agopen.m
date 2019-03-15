%agopen;
%Opens up Agilent Function Generator
%Creates a global pointer called AG
%Not a true function as it has to pass the global variable

%James McLaughlan
%University of Leeds
%May 2010

global AG
%{
AGaddr=10;

CleanGPIB(AGaddr);
AG=gpib('ni',0,AGaddr);
%}

COM = 'COM4';%When using the Serial Hub %'COM1';
p   = nextpow2(280360); % increasing buffer size to enable waveforms to be transmitted 512 default (p = 9)

AG = serial(COM);
AG.OutputBufferSize = 2^p;
fopen(AG);
%AG.TimeOut=300;

AG.UserData=query(AG,'*IDN?');
%disp(['Initialized ' idn]);
