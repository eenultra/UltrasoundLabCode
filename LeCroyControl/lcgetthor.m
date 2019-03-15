function [vdiv]= LCgetVDIV(chanstr);
%[vdiv]= LCgetVDIV(chanstr);
%
global lc

fprintf(lc,[chanstr ':VDIV?']);
rettext=fscanf(lc);
%bidx=findstr(rettext,' ');
bidx=1:length(rettext);
vdiv=str2num(rettext(bidx(1):bidx(end)));
