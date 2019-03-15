function [msiz] = lcsetmsiz(msiz);
%[msiz]= lcsetmsiz(msiz);
%
global lc

fprintf(lc,['MSIZ ' num2str(msiz)]);
fprintf(lc,['MSIZ?']);
rettext=fscanf(lc);
bidx=1:length(rettext);
msiz=str2num(rettext(bidx(1):bidx(end)));
