function arbTo33500(arb,IP,amp,sRate,name)
%This function connects to a 33500A/B waveform generator and sends it an
%arbitrary waveform from Matlab via LAN. The input arguments are as
%follows:
%arb --> a vector of the waveform points that will be sent to a 33500A/B
%waveform generator
%IP --> IP address (string) of the 33500A/B that you want to send the waveform to
%amp --> amplitude of the arb waveform as Vpp
%sRate --> sample rate of the arb waveform
%name --> The same of the arb waveform as a string
%Note: this function requires the instrument control toolbox

%vAddress = ['TCPIP0::' IP '::inst0::INSTR']; %build visa address string to connect
fgen = visa('AGILENT',vAddress); %build IO object
fgen.Timeout = 15; %set IO time out
%calculate output buffer size
buffer = length(arb)*8;
set (fgen,'OutputBufferSize',(buffer+125));

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

%create waitbar for sending waveform to 33500
mes = ['Connected to ' idn ' sending waveforms.....'];
h = waitbar(0,mes);

%Reset instrument
fprintf (fgen, '*RST');

%make sure waveform data is in column vector
if isrow(arb) == 0
    arb = arb';
end

%set the waveform data to single precision
arb = single(arb);

%scale data between 1 and -1
mx = max(abs(arb));
arb = (1*arb)/mx;

%update waitbar
waitbar(.1,h,mes);

%send waveform to 33500
fprintf(fgen, 'SOURce1:DATA:VOLatile:CLEar'); %Clear volatile memory
fprintf(fgen, 'FORM:BORD SWAP');  %configure the box to correctly accept the binary arb points
arbBytes=num2str(length(arb) * 4); %# of bytes
header= ['SOURce1:DATA:ARBitrary ' name ', #' num2str(length(arbBytes)) arbBytes]; %create header
binblockBytes = typecast(arb, 'uint8');  %convert datapoints to binary before sending
fwrite(fgen, [header binblockBytes], 'uint8'); %combine header and datapoints then send to instrument
fprintf(fgen, '*WAI');   %Make sure no other commands are exectued until arb is done downloadin
%update waitbar
waitbar(.8,h,mes);
%Set desired configuration for channel 1
command = ['SOURce1:FUNCtion:ARBitrary ' name];
%fprintf(fgen,'SOURce1:FUNCtion:ARBitrary GPETE'); % set current arb waveform to defined arb testrise
fprintf(fgen,command); % set current arb waveform to defined arb testrise
command = ['MMEM:STOR:DATA1 "INT:\' name '.arb"'];
%fprintf(fgen,'MMEM:STOR:DATA1 "INT:\GPETE.arb"');%store arb in intermal NV memory
fprintf(fgen,command);
%update waitbar
waitbar(.9,h,mes);
command = ['SOURCE1:FUNCtion:ARB:SRATe ' num2str(sRate)]; %create sample rate command
fprintf(fgen,command);%set sample rate
fprintf(fgen,'SOURce1:FUNCtion ARB'); % turn on arb function
command = ['SOURCE1:VOLT ' num2str(amp)]; %create amplitude command
fprintf(fgen,command); %send amplitude command
fprintf(fgen,'SOURCE1:VOLT:OFFSET 0'); % set offset to 0 V
fprintf(fgen,'OUTPUT1 ON'); %Enable Output for channel 1
fprintf('Arb waveform downloaded to channel 1\n\n') %print waveform has been downloaded

%get rid of message box
waitbar(1,h,mes);
delete(h);

%Read Error
fprintf(fgen, 'SYST:ERR?');
errorstr = fscanf (fgen);

% error checking
if strncmp (errorstr, '+0,"No error"',13)
   errorcheck = 'Arbitrary waveform generated without any error\n';
   fprintf (errorcheck)
else
   errorcheck = ['Error reported: ', errorstr];
   fprintf (errorcheck)
end

fclose(fgen);