stCartMoveTank([0 300 -100 90 0]); % move load position for arm


stCartMoveTank([0 300 -0 90 0]); % move load position for arm
%%

tpause = 0.1;

input('Ready?');
for i=1%:5
          
i

stCartMoveTank([-25 400  50 110 9]);pause(tpause); %pos 1 (right)
stCartMoveTank([-25 300  80 90 9]);pause(tpause); %pos 2 (middle)
stCartMoveTank([-25 200  50 70 9]);pause(tpause); %pos 3 (left)
stCartMoveTank([0 200  50 70 0]);pause(tpause); %pos 4 (left)
stCartMoveTank([0 300  80 90 0]);pause(tpause); %pos 5 (middle)
stCartMoveTank([0 400  50 110 0]);pause(tpause); %pos 6 (right)
stCartMoveTank([25 400  50 110 -10]);pause(tpause); %pos 7 (right)
stCartMoveTank([25 300  80 90 -10]);pause(tpause); %pos 8 (middle)
stCartMoveTank([25 200  50 70 -10]);pause(tpause); %pos 9 (left)

stCartMoveTank([0 300  80 90 0]);pause(tpause); %pos 10 (clear, to stop hitting phantom on way back)

end


%%

