function [trigdelay]= LCgetTRDL;
%[trigdelay]= LCgetTRDL;
%
global lc

fprintf(lc,'TRDL?');
rettext=fscanf(lc);
%bidx=findstr(rettext,' ');
bidx=1:length(rettext);
trigdelay=-1*str2num(rettext(bidx(1):bidx(end)));

if trigdelay<0,
    %Result is in percent of screen time base
    fprintf(lc,'TDIV?');
    rettext=fscanf(lc);
    %bidx=findstr(rettext,' ');
    bidx=1:length(rettext);
    tscreen=10*str2num(rettext(bidx(1):bidx(end)));
    trigdelay=tscreen*trigdelay/100;
end
