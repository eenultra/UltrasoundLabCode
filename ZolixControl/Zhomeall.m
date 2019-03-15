function Zhomeall

%Zhomeall

%homes all stages

%Creates a global pointer called ZO
%Not a true function as it has to pass the global variable

%James McLaughlan
%University of Leeds
%Oct 2013


global ZO Zspd

input('WARNING all stages will be moved to home position ensure path is clear!');

fprintf(ZO, 'GoHome X');idtest =fscanf(ZO);  % changed 16th Oct 2014 due to problems with system, should be X
fprintf(ZO, 'GoHome Y');idtest =fscanf(ZO);
fprintf(ZO, 'GoHome Z');idtest =fscanf(ZO);

%disp('Homing, please wait');pause(300/Zspd);
input('Press any key when system has finished homing');

idtest =fscanf(ZO);
idtest =fscanf(ZO);
idtest =fscanf(ZO);

clear idtest



