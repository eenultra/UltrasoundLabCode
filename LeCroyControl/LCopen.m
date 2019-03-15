function lc = LCopen

%James McLaughlan
%Leeds University
%May 2011


h= figure(42);
%set(h,'Visible','off');

lc = actxcontrol('LeCroy.ActiveDSOCtrl.1'); % Load ActiveDSO control
invoke(lc,'MakeConnection','IP:129.11.177.49'); % Substitute your choice of IP address here
invoke(lc,'WriteString','*IDN?',true); % Query the scope name and model number
ID=invoke(lc,'ReadString',1000) % Read back the scope ID to verify connection

%set(h,'Visible','off');


%'IP:129.11.177.49' - ip for network scope.
%'IP:192.168.1.2'