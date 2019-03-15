function [vdiv]= LCgetVDIV(lc,chanstr)
%[vdiv]= LCgetVDIV(chanstr);
%
%{
fprintf(lc,[chanstr ':VDIV?']);
rettext=fscanf(lc);
%bidx=findstr(rettext,' ');
bidx=1:length(rettext);
vdiv=str2num(rettext(bidx(1):bidx(end)));
%}

invoke(lc,'WriteString',[chanstr ':VDIV?'],true);
vd=invoke(lc,'ReadString',100);
vdiv = str2double(vd);
