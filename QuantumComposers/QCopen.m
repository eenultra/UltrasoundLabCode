%QCopen;
%Opens up QC system and 

% Error Codes
% ok<cr><lf> or ?n<cr><lf>
% Where "n" is one of the following error codes:
% 1 Incorrect prefix, i.e. no colon or * to start command.
% 2 Missing command keyword.
% 3 Invalid command keyword.
% 4 Missing parameter.
% 5 Invalid parameter.
% 6 Query only, command needs a question mark.
% 7 Invalid query, command does not have a query form.
% 8 Command unavailable in current system state.

%Creates a global pointer called QC
%Not a true function as it has to pass the global variable

%James McLaughlan
%University of Leeds
%Jan 2014



global QC 

COM = 'COM3';%COM16 When using Serial Hub %'COM1';

QC = serial(COM,'BaudRate',115200,'Terminator','CR/LF','DataBits',8,'StopBits',1);
fopen(QC);

pause(1);
fprintf(QC, '*IDN?')
X = fscanf(QC);
disp('Connected');
disp(['System Info: ' X]);