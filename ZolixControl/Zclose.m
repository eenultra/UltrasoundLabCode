function Zclose

global ZO

fclose(ZO);
delete(ZO);
disp('Disconnected ZO');

clear initX initY initZ spdX spdY spdZ