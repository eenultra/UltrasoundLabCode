function LCsetTRDL(lc,trigdelay)
%LCsetTRDL(trigdelay);


if trigdelay<0,
    %Result is in percent of screen time base
    invoke(lc,'WriteString','TDIV?',true);
    rettext=invoke(lc,'ReadString',100);
    %bidx=findstr(rettext,' ');
    bidx=1:length(rettext);
    tscreen=10*str2num(rettext(bidx(1):bidx(end)));
    trigdelay=-100*trigdelay/tscreen;
else
    trigdelay=-trigdelay;
end


invoke(lc,'WriteString',['TRDL ' num2str(trigdelay)],true);
%fprintf(lc,['TRDL ' num2str(trigdelay)]);

