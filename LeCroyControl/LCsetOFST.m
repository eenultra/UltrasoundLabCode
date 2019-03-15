function LCsetOFST(chanstr,vofst);
%LCsetOFST(lc,chanstr,vofst);
%
global lc

fprintf(lc,[chanstr ':OFST ' num2str(vofst)]);

