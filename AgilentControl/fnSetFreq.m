function fnSetFreq(frequency)
%agSetFreq(frequency);
%Sets frequency of output

%Robin Cleveland
%Boston University
%May 2006

global fgen

fprintf(fgen,['FREQ ' num2str(frequency)]);
