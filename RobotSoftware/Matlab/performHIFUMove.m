function [ endEarly, nextStartOpOrIdx, nextEndOpOrIdx ] = ...
    performHIFUMove( obj, startOpIdx, endOpIdx, loopIdx, varargin )  %#ok<INUSL>
% Jump to next operation.
tpause=2;
disp('moving arm')

switch loopIdx
    
    case 1
        % move to position 1
        stCartMoveTank([0 400 -2 105 0]);pause(tpause); %pos 1 (right)   
    case 2
        % move to position 2
        stCartMoveTank([0 300  9 90 0]);pause(tpause); %pos 2 (middle)  
    case 3
        % move to position 3
        stCartMoveTank([0 200  -2 75 0]);pause(tpause); %pos 3 (left)
        
    otherwise
        % choose a safe backup position
        stCartMoveTank([0 300  -2 90 0]);pause(tpause); %pos 10 (clear, to stop hitting phantom on way back)   
end

% Default output values.
endEarly = false;
nextStartOpOrIdx = 1;
nextEndOpOrIdx = 1;

end






