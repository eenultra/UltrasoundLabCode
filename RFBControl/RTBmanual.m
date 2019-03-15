%RBF: Manual Recording Method from user manual (p25)

M0=zeros(4,1); % M(0)measurement time
M10=zeros(4,1); % M(10)measurement time
M20=zeros(4,1); % M(20) measurement time


for i=1:4 % 4 repeats of this process

    M0(i,1) = mtRead; %M(0) TXD_OFF

    %agon %turn on TXD

    pause(10);

    M10(i,1) = mtRead; %M(10) TXD_ON

    %agoff %turn off TXD

    pause(10);

    M20(i,1) = mtRead; %M(20) TXD_OFF


end

%OFF_ON = mean(M10-M0);


