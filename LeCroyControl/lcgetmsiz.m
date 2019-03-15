function [msiz]= lcgetmsiz;
%[msiz]= lcgetmsiz;
%
global lc

fprintf(lc,['MSIZ?']);
rettext=fscanf(lc);
bidx=1:length(rettext);
msiz=str2num(rettext(bidx(1):bidx(end)));
