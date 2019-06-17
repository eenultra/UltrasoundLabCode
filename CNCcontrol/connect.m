function [inst] = connect(IP,ch)

scopeNotFound = 1;

maxAttempts = 100;

nAttempts = 1;

while(scopeNotFound == 1)
    disp(['Checking for Scope via ethernet ' IP ]);
    [scopeNotFound,~] = dos(['ping ' IP ' -n 1 -w 100']);
    nAttempts = nAttempts + 1;
    
    if(nAttempts == maxAttempts)
       return; 
    end
    pause(0.1);
end



disp(['Connecting to Agilent N6700B PSU via ethernet ' IP ]);
inst = connectSockets(IP,5025);

cmd = '*IDN?';
sendSockets(inst,cmd);

data = receiveLnSockets(inst,80);
disp(['Instrument Response: ' data( 1:(end-1) ) ])