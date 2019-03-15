function LCsetVDIV(lc,chanstr,vdiv)
%LCsetVDIV(chanstr,vdiv);
%

%fprintf(lc,[chanstr ':VDIV ' num2str(vdiv)]);
invoke(lc,'WriteString',[chanstr ':VDIV ' num2str(vdiv)],true);
