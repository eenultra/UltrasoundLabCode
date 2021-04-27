function fnClose
%st=agclose;
%Closes handle to agilent function generator - returns close status

global fgen

fclose(fgen);
delete(fgen)


