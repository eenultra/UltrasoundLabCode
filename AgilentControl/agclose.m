function agclose
%st=agclose;
%Closes handle to agilent function generator - returns close status

global AG

fclose(AG);
delete(AG)


