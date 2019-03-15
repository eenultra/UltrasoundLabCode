function [status]= LCcal;
%[status]= LCcal;
%
global lc

fprintf(lc,['*CAL?']);
rettext=fscanf(lc);
%bidx=findstr(rettext,' ');
bidx=1:length(rettext);
status=str2num(rettext(bidx(1):bidx(end)));
