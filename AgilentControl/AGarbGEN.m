% Generate an ARB function for the Agilent FUNC

% James McLaughlan
% Leeds University
% April 2011
clear Ns fs Cyc WF win t

Ns  = 2^15; %65534 sample number (64K at present, 2^16)
fs  = 1/Ns;  %center frequency;
Cyc = 50;     % number of cycles

t = 0:Ns;

WF  = sin(2*pi*(fs*Cyc)*t);
win = tukeywin(length(WF),0.6);

WF = WF.*win';

plot(t,WF);

