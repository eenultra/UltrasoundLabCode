%Starts all channels running
%Creates a global pointer called QC
%Not a true function as it has to pass the global variable

%James McLaughlan
%University of Leeds
%May 2021

global QC 
fprintf(QC, ':PULS0:STAT ON')
X = fscanf(QC);
