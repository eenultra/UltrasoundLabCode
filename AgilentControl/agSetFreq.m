function agSetFreq(frequency);
%agSetFreq(frequency);
%Sets frequency of output

%Robin Cleveland
%Boston University
%May 2006

global AG

fprintf(AG,['FREQ ' num2str(frequency)]);
