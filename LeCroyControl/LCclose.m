function LCclose(lc)

% DATA HAS BEEN TRANSFERRED -- TERMINATE CONNECTION WITH SCOPE 
invoke(lc,'Disconnect'); % disconnect from scope
close(gcf); % close current figure that had been opened by the activexcontrol
clear lc