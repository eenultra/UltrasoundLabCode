function waittime=LCwaitAVG(lc,wfchan,timeout)
%LCwaitAVG(wfchan,timeout);
%Waits for averaging (or other waveform process) to complete
%wfchan = TA TB TC TD
%wfchan = C   signal acquired on any channel
%wfchan = TR  trigger is ready
%
%Returns estimate of time take for processing to occur
%
%Default timeout is 20 seconds

%Robin Cleveland, Boston University, May 2006
%Edit James McLaughlan July 2011

pausetime=0.05;
if nargin<3,
  timeout=20;
end

invoke(lc,'WriteString','INR?',true);
inr=str2double(invoke(lc,'ReadString',100));

switch wfchan
case 'TA' 
    mask=256;
    fprintf(lc,'CLSW');
case 'TB' 
    mask=512;
    fprintf(lc,'CLSW');
case 'TC' 
    mask=1024;
    fprintf(lc,'CLSW');
case 'TD' 
    mask=2048;
    fprintf(lc,'CLSW');
case 'TR' 
    mask=8192;
case 'C' 
    mask=1;
otherwise 
    mask=0;
    warning(['Waveform channel ' wfchan ' not recognised - no waiting occured']);
    return;
end

waittime=0;
mask;
inr=0;
while (~(bitand(inr,mask)))&&(waittime<timeout),
    pause(pausetime);
    waittime=waittime+pausetime;
    invoke(lc,'WriteString','INR?',true);
    inr=str2double(invoke(lc,'ReadString',100));
end
