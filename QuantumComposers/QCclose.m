function QCclose

global QC

fclose(QC);
delete(QC);
disp('Disconnected QC');