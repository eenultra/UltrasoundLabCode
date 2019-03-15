function [tdiv]= lcgetdiv;
%[tdiv]= lcgettdiv;
%
global lc

fprintf(lc,['TDIV?']);
rettext=fscanf(lc);
bidx=1:length(rettext);
tdiv=str2num(rettext(bidx(1):bidx(end)));
