%Runs a basic 2 or 3D rastor scan using a single element TXD, pulser and LeCroy.
%by James McLaughlan
%University of Leeds
%May 2017

xRange = -10:5:10;
yRange = 280:10:320;
zRange = -150:10:-120;

input('Arm about to move, is path clear?');
for i=1:length(zRange)
    for j=1:length(yRange)
        for k=1:length(xRange)

    x = xRange(k); %x-axis position
    y = yRange(j); %y-axis position
    z = zRange(i); %z-axis position
    p = 90;         %pitch
    r = 90;        %rotation
    disp(['Pos X:' num2str(x) 'mm, Y:' num2str(y) 'mm, Z:' num2str(z) 'mm']);
    out = stCartMove([x y z p r]);pause(0.1); % can not use ALIGN with this command

        end
    end
end

time = x;
