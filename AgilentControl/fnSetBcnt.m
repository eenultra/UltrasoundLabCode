function fnSetBcnt(burstcount)
%agSetBcnt(burstcount)
%Sets burst count

%James McLaughlan
%Leeds University
%May 2021

global fgen

fprintf(fgen,['SOUR:BM:NCYC ' num2str(burstcount)]);
