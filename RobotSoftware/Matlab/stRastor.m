
xRange = -25:1:25;
yRange = 275:1:325;
zRange = -150;

for i=1:length(zRange)
    for j=1:length(yRange);
        for k=1:length(xRange);

    x = xRange(k); %x-axis position
    y = yRange(j); %y-axis position
    z = zRange(i); %z-axis position
    p = 90;         %pitch
    r = 90;        %rotation

    out = stCartMove([x y z p r]);
    
        end
    end
end
