function agSetBcnt(burstcount);
%agSetBcnt(burstcount)
%Sets burst count

%Robin Cleveland
%Boston University
%May 2006

global AG

fprintf(AG,['SOUR:BM:NCYC ' num2str(burstcount)]);
